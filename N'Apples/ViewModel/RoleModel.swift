//
//  UserModel.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit
import SwiftUI

class RoleModel: ObservableObject {
    
    private let database = CKContainer.default().publicCloudDatabase
    
    @Published var role = [Role]() {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    var onChange : (() -> Void)?
    var onError : ((Error) -> Void)?
    var notificationQueue = OperationQueue.main
    
    var records = [CKRecord]()
    var insertedObjects = [Role]()
    var deletedObjectIds = Set<CKRecord.ID>()
    
    
    func retrieveAllUsername(username: String) async throws {
        let predicate: NSPredicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: Role.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults {
            if let data = try? tmp1.1.get() {
                self.records.append(data)
                
            }
        }
        
        self.updateRole()
        
    }
    
    
    func retrieveAllCollaborators(idEvent: String) async throws {
        records.removeAll()
        let predicate: NSPredicate = NSPredicate(format: "idEvent == %@", idEvent)
        let query = CKQuery(recordType: Role.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        print("Retrive all collaborator role.")
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records.append(data)
            }
        }
        
        self.updateRole()
    }
    
    
    func retrieveOneCollaborator(idEvent: String, username: String) async throws  -> Bool {
        let predicate: NSPredicate = NSPredicate(format: "idEvent == %@ AND username == %@", idEvent, username)
        
        let query = CKQuery(recordType: Role.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults {
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        
        self.updateRole()
        
        if (self.records == []) {
            return false
        } else {
            return true
        }
        
        
    }
    
    
    func insert(username: String, permission: Int, idEvent: String) async throws {
        
        var createRole = Role()
        createRole.username = username
        if (permission == 0) {
            createRole.permission = [1, 0, 0]
        }
        if (permission == 1) {
            createRole.permission = [0, 1, 0]
            insertEventOnServer(idEvent: idEvent, nameList: username)
        }
        if (permission == 2) {
            createRole.permission = [0, 0, 1]
        }
        if (permission == 3) {
            createRole.permission = [0, 0, 0]
        }
        createRole.idEvent = idEvent
        
        do {
            let _ = try await database.save(createRole.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createRole)
        self.updateRole()
        return
    }
    
    
    func insertTmp(username: String, permission: [Int], idEvent: String) async throws {
        
        var createRole = Role()
        createRole.username = username
        createRole.permission = permission
        createRole.idEvent = idEvent
        
        do {
            let _ = try await database.save(createRole.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createRole)
        self.updateRole()
        return
    }
    
    
    func delete(at index : Int) async throws {
        let recordId = self.role[index].record.recordID
        do {
            let _ = try await database.deleteRecord(withID: recordId)
        } catch let error {
            print(error)
            return
        }
        deletedObjectIds.insert(recordId)
        self.updateRole()
        return
    }
    
    func deleteRole(at offset : IndexSet) {
        offset.forEach { i in
            let recordId = self.role[i].record.recordID
            Task {
                do {
//                    let _ = try await database.deleteRecord(withID: recordId)
                    try await deleteCascade(idEvent: role[i].idEvent)
                } catch let error {
                    print(error)
                    return
                }
                deletedObjectIds.insert(recordId)
            }
        }
        
        
        self.updateRole()
        role.remove(atOffsets: offset)
        
        return
    }
    
    func deleteWithoutUpdate(at index : Int) async throws {
        let recordId = self.role[index].record.recordID
        do {
            let _ = try await database.deleteRecord(withID: recordId)
        } catch let error {
            print(error)
            return
        }
        deletedObjectIds.insert(recordId)
        //        self.updateRole()
        return
    }
    
    
    func update(usename: String, idEvent: String, permission: Int) async throws {
        
        var tmp: [Int]
        @State var flag = false
        
        flag = try await retrieveOneCollaborator(idEvent: idEvent, username: usename)
        
        if(flag) {
            
            tmp = role.first!.permission
            
            tmp[permission] = 1
            
            try await delete(at: 0)
            
            try await insertTmp(username: usename, permission: tmp, idEvent: self.role.first?.idEvent ?? "0")
            
            self.updateRole()
            
        } else {
            
            try await insert(username: usename, permission: permission, idEvent: idEvent)
        }
    }
    
    
    func deleteCascade(idEvent: String) async throws {
        reset()
        try await retrieveAllCollaborators(idEvent: idEvent)
        
        for i in 0..<role.count {
            
            try await deleteWithoutUpdate(at: i)
        }
        
        self.updateRole()
        
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.records.removeAll()
            self.role.removeAll()
        }
    }
    
    func updateRole() {
        
        var knownIds = Set(records.map { $0.recordID })
        
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var role = records.map { record in Role(record: record) }
        
        role.append(contentsOf: self.insertedObjects)
        role.removeAll { errand in
            deletedObjectIds.contains(errand.record.recordID)
        }
        
        DispatchQueue.main.async {
            self.role = role
        }
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
    
    func updateRole2() {
        
        var knownIds = Set(records.map { $0.recordID })
        
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var role = records.map { record in Role(record: record) }
        
        role.append(contentsOf: self.insertedObjects)
        
        
        self.role = role
        
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
    
}

