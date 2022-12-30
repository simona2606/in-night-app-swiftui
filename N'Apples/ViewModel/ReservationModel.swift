//
//  ReservationModel.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit
import CoreMIDI

class ReservationModel: ObservableObject {
    
    private let database = CKContainer.default().publicCloudDatabase
    
    @Published var reservation = [Reservation]() {
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
    var insertedObjects = [Reservation]()
    var deletedObjectIds = Set<CKRecord.ID>()
    
    func retrieveAllEmail(email: String) async throws {
        let predicate: NSPredicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: User.recordType, predicate: predicate)
        
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
                self.updateReservation()
            }
        }
    }
    
    func retrieveAllIdDecrypt(id: String) async throws {
        DispatchQueue.main.async {
            self.records.removeAll()
            self.reservation.removeAll()
        }
           
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: Reservation.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        print(tmp.matchResults)
        for tmp1 in tmp.matchResults {
            if let data = try? tmp1.1.get() {
                self.records = [data]
                
            }

        }
        
        self.updateReservation()

//        let key = keyFromPassword(id)
//
//
//        for i in 0..<reservation.count {

//            reservation[i].name = try decryptStringToCodableOject(String.self, from: reservation[i].name, usingKey: key)
//            reservation[i].surname = try decryptStringToCodableOject(String.self, from: reservation[i].surname, usingKey: key)
//            reservation[i].email = try decryptStringToCodableOject(String.self, from: reservation[i].email, usingKey: key)
//        }


    }
    
    func retrieveAllEventIdDecrypt(idEvent: String) async throws {
        
        DispatchQueue.main.async {
            self.records.removeAll()
            self.reservation.removeAll()
        }
        let predicate: NSPredicate = NSPredicate(format: "idEvent == %@", idEvent)
        let query = CKQuery(recordType: Reservation.recordType, predicate: predicate)
        
        
        let tmp = try await self.database.records(matching: query)
        print(tmp.matchResults)
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records.append(data)
                
            }

        }
        
        self.updateReservation()

        
//        for i in 0..<reservation.count {
//            let key = keyFromPassword(reservation[i].id)
//            reservation[i].name = try decryptStringToCodableOject(String.self, from: reservation[i].name, usingKey: key)
//            reservation[i].surname = try decryptStringToCodableOject(String.self, from: reservation[i].surname, usingKey: key)
//            reservation[i].email = try decryptStringToCodableOject(String.self, from: reservation[i].email, usingKey: key)
//
//        }

    }
    
 
    func retrieveAllId(id: String) async throws {
        DispatchQueue.main.async {
            self.records.removeAll()
            self.reservation.removeAll()
        }
        
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: Reservation.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults {
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        
        if !self.records.isEmpty {
            self.updateReservation()
        } else {
            getSingleReservation(id: id)
        }
        
    }
    
    
    func retrieveAllName(name: String) async throws {
        let predicate: NSPredicate = NSPredicate(format: "name == %@", name)
        let query = CKQuery(recordType: Reservation.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        self.updateReservation()
        
    }
    
    func insert(event: String,id: String, name: String, surname: String, email: String, nameList: String, numFriends: Int) async throws {
        
        var createReservation = Reservation()
        createReservation.idEvent = event
        createReservation.id = id
        createReservation.name = name
        createReservation.surname = surname
        createReservation.email = email
//        createReservation.name = try encryptParameter(id, name)
//        createReservation.surname = try encryptParameter(id, surname)
//        createReservation.email = try encryptParameter(id, email)
        createReservation.nameList = nameList
        createReservation.numFriends = numFriends
        createReservation.numScan = 0
        
        do {
            let _ = try await database.save(createReservation.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createReservation)
        self.updateReservation()
        return
    }
    
    func insertUpdate(event: String, id: String, name: String, surname: String, email: String, nameList: String, numFriends: Int, numScan: Int) async throws {
        
        var createReservation = Reservation()
        createReservation.idEvent = event
        createReservation.id = id
        createReservation.name = name
        createReservation.surname = surname
        createReservation.email = email
        createReservation.nameList = nameList
        createReservation.numFriends = numFriends
        createReservation.numScan = numScan
        print("Update")
        
        do {
            let _ = try await database.save(createReservation.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createReservation)
        print(reservation)
        self.updateReservation()
        return
    }
    
    
    func delete(at index : Int) async throws {
        let recordId = self.reservation[index].record.recordID
        do {
            let _ = try await database.deleteRecord(withID: recordId)
        } catch let error {
            print(error)
            return
        }
        deletedObjectIds.insert(recordId)
        self.updateReservation()
        return
    }
 
    
    func updateNumScan(id: String, numscan: Int) async throws {
        DispatchQueue.main.async {
            self.records.removeAll()
            self.reservation.removeAll()
        }
        var numScan = numscan
        
        try await retrieveAllId(id: id)
       
        if(!self.reservation.isEmpty) {
            numScan = self.reservation.first!.numScan
        }
        
        if(!self.reservation.isEmpty && numScan < reservation.first!.numFriends) {
            var rec = self.reservation.first!
            rec.numScan = rec.numScan + 1
    
            for i in 0..<self.reservation.count {
                try await delete(at: i)
            }
        
            
            try await insertUpdate(event: rec.idEvent, id: rec.id, name: rec.name, surname: rec.surname, email: rec.email, nameList: rec.nameList, numFriends: rec.numFriends, numScan: rec.numScan)
           
            try await retrieveAllIdDecrypt(id: id)
            
            self.updateReservation()
           
        }
        
    }
    
    private func updateReservation() {
        
        var knownIds = Set(records.map { $0.recordID })
        
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var reservation = records.map { record in Reservation(record: record) }
        
        reservation.append(contentsOf: self.insertedObjects)
        reservation.removeAll { errand in
            deletedObjectIds.contains(errand.record.recordID)
        }
        
        DispatchQueue.main.sync {
            self.reservation = reservation
        }
        
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
    
}


