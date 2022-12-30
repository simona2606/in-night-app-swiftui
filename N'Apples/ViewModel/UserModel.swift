//
//  UserModel.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit
import CryptoKit
import SwiftUI


class UserModel: ObservableObject {
    
    private let database = CKContainer.default().publicCloudDatabase
    
    @Published var user = [User]() {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    @Published var events = [Event]()
    
    @Published var username = ""
    @Published var email = ""
    @Published var userID = ""
    @Published var password = ""
    

    init() { }
    
    init(currentUser: User) {
        self.username = currentUser.username
        self.email = currentUser.email
        self.userID = currentUser.id
        self.password = currentUser.password
    }
    
    
    
    var onChange : (() -> Void)?
    var onError : ((Error) -> Void)?
    var notificationQueue = OperationQueue.main
    
    var records = [CKRecord]()
    var insertedObjects = [User]()
    var deletedObjectIds = Set<CKRecord.ID>()
    
    func retrieveAllUsernamePassword(username: String, password: String) async throws {
        
        let key = keyFromPassword(password)
        
        let predicate: NSPredicate = NSPredicate(format: "username == %@ ", username)
        let query = CKQuery(recordType: User.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        
        self.updateUser()
        
        for i in 0..<user.count {
            let tmpPass = try decryptStringToCodableOject(String.self, from: user[i].password, usingKey: key)


            if(tmpPass == password){
                user[i].password = tmpPass

            }
        }
        
    }
    
    func retrieveAllId(id: String) async throws {
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: User.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        
        self.updateUser()
    }
    
    func retrieveAllName(username: String) async throws {
        let predicate: NSPredicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: User.recordType, predicate: predicate)

        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        
        self.updateUser()
    }
    
    func retrieveAll() async throws {
        let query = CKQuery(recordType: User.recordType, predicate: NSPredicate(value: true))

        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        
        self.updateUser()
    }
    
    
    func retrieveAllEmail(email: String) async throws {
  
        records.removeAll()
        let predicate: NSPredicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: User.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }

        self.updateUser()
    }
    
    func insert(username: String, password: String, email: String) async throws {
        
        var createUser = User()
        createUser.username = username
        
        let key = keyFromPassword(password)
        
        
        let encryptedPassword = try encryptCodableObject(password, usingKey: key)
//        let encryptedEmail = try encryptCodableObject(email, usingKey: key)

        createUser.password = encryptedPassword
        createUser.email = email
        createUser.id = UUID().uuidString
        
        
        do {
            let _ = try await database.save(createUser.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createUser)
        self.updateUser()
        return
    } 
    
    func insertApple(username: String, email: String, id: String) async throws {
        
        var createUser = User()
        createUser.username = username
        createUser.email = email
        createUser.id = id
        
        print("username: \(createUser.username)" )
        print("email: \(createUser.email)" )
        print("id: \(createUser.id)" )
        
        do {
            let _ = try await database.save(createUser.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createUser)
        self.updateUser()
        return
    }
    
    func insertPhoto(username: String, password: String, imageUser: UIImage?) async throws {
        
        var createUser = User()
        createUser.username = username
        
        let key = keyFromPassword(password)
        
        let encryptedPassword = try encryptCodableObject(password, usingKey: key)
        
        createUser.password = encryptedPassword
        
        guard
            let image = imageUser,
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("Giorgio.jpeg"),
            let data = image.jpegData(compressionQuality: 1.0) else { return }
        
        do {
            
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            createUser.photo = asset
            
            let _ = try await database.save(createUser.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createUser)
        self.updateUser()
        return
        
        
    }
    
    func delete(at index : Int) async throws {
        let recordId = self.user[index].record.recordID
        do {
            let _ = try await database.deleteRecord(withID: recordId)
        } catch let error {
            print(error)
            return
        }
        deletedObjectIds.insert(recordId)
        self.updateUser()
        return
    }
    
    func update(user: User, username: String, password: String) async throws {
        
        var singleUser = User()
        singleUser.username = username
        
        let key = keyFromPassword(password)
        
        let encryptedPassword = try encryptCodableObject(password, usingKey: key)
        
        singleUser.password = encryptedPassword
        
        let _ = try await self.database.modifyRecords(saving: [singleUser.record], deleting: [user.record.recordID], savePolicy: .changedKeys, atomically: true)
        self.updateUser()
    }
    
    func updatePw(user: User, password: String) async throws {
        
        var singleUser = User()
        singleUser.username = user.username
        
        let key = keyFromPassword(password)
        
        let encryptedPassword = try encryptCodableObject(password, usingKey: key)
        
        singleUser.password = encryptedPassword
        
        let _ = try await self.database.modifyRecords(saving: [singleUser.record], deleting: [user.record.recordID], savePolicy: .changedKeys, atomically: true)
        self.updateUser()
    }
    
    func reset() {
        records.removeAll()
        user.removeAll()
    }
    
    
    private func updateUser() {
        
        var knownIds = Set(records.map { $0.recordID })
        
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var user = records.map { record in User(record: record) }
        
        user.append(contentsOf: self.insertedObjects)
        user.removeAll { errand in
            deletedObjectIds.contains(errand.record.recordID)
        }
        
        DispatchQueue.main.async {
            self.user = user
        }
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
    
}

