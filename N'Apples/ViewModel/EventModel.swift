//
//  EventModel.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit
import SwiftUI

class EventModel: ObservableObject {
    
    private let database = CKContainer.default().publicCloudDatabase
    
    @Published var event = [Event]() {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    @Published var singleEvent = Event()
 
    var eventID: String?
    var eventName: String?
    var eventLoaction: String?
    var eventCapability: Int?
    var eventDate: Date?
    var eventInfo: String?
    var eventTable: [String]?
    var eventPrice: [Int]?
    var eventAddress: String?
    var eventLists: [String]?
    
    init() { }
    
    init(currentEvent: Event) {
        self.eventID = currentEvent.id
        self.eventName = currentEvent.name
        self.eventLoaction = currentEvent.location
        self.eventCapability = currentEvent.capability
        self.eventDate = currentEvent.date
        self.eventInfo = currentEvent.info
        self.eventTable = currentEvent.table
        self.eventPrice = currentEvent.price
        self.eventAddress = currentEvent.address
        self.eventLists = currentEvent.lists
    }
    
    
    var onChange : (() -> Void)?
    var onError : ((Error) -> Void)?
    var notificationQueue = OperationQueue.main
    
    
    var records = [CKRecord]()
    var insertedObjects = [Event]()
    var deletedObjectIds = Set<CKRecord.ID>()
    
    func retrieveAllName(name: String) async throws {
        
        let predicate: NSPredicate = NSPredicate(format: "name == %@", name)
        let query = CKQuery(recordType: Event.recordType, predicate: predicate)
        
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        self.updateEvent()
    }
    
    func retrieveAllId(id: String) async throws {
        
        print("ID event: \(id)")
        
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: Event.recordType, predicate: predicate)
        let tmp = try await self.database.records(matching: query)
        print("retrive val id event")
        
        for tmp1 in tmp.matchResults {
            if let data = try? tmp1.1.get() {
                self.records.append(data)
            }
        }
        self.updateEvent()
        
    }
    
    func retrieveTypology(id: String, table: [String]) async throws {
        //reset()
        let predicate: NSPredicate = NSPredicate(format: "id == %@ AND table == %@ ", id, table as CVarArg)
        print("retirevall event pred \(predicate)")
        let query = CKQuery(recordType: Event.recordType, predicate: predicate)
        let tmp = try await self.database.records(matching: query)
        
        for tmp1 in tmp.matchResults {
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        self.updateEvent()
        
//        if table != [""] {
//            return true
//        } else {
//            return false
//        }
        
    }
    
    func retrieveAll(name: String, location: String, date: Date) async throws {
        reset()
        let predicate: NSPredicate = NSPredicate(format: "name == %@ AND location == %@ AND date == %@ ", name, location, date as CVarArg)
        let query = CKQuery(recordType: Event.recordType, predicate: predicate)
        let tmp = try await self.database.records(matching: query)
        print("retirevall event")
        
        for tmp1 in tmp.matchResults{
            if let data = try? tmp1.1.get() {
                self.records = [data]
            }
        }
        self.updateEvent()
    }
    
    func insertAll(idEvent: String,name: String, address: String, location: String, info: String,/* poster: CKAsset,*/ capability: Int, date: Date, lists: [String], table: [String], price: [Int], timeForPrice: [Date]) async throws {
        
        var createEvent = Event()
        createEvent.id = idEvent
        createEvent.name = name
        createEvent.address = address
        createEvent.location = location
        createEvent.info = info
        createEvent.capability = capability
        createEvent.date = date
        createEvent.lists = lists
        createEvent.table = table
        createEvent.price = price
        createEvent.timeForPrice = timeForPrice
        
        do {
            let _ = try await database.save(createEvent.record)
        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createEvent)
        self.updateEvent()
        return
    }

    func update(idEvent: String, name: String, address: String, location: String, info: String, capability: Int, date: Date, lists: [String], table: [String], price: [Int],timeForPrice: [Date]) async throws {
        
        try await retrieveAllId(id: idEvent)
        print("id nell'update: \(idEvent)")
        
        print("Printo i valori prima del delete: \(name), \(address), \(location), \(info), \(capability), \(date), \(lists), \(table), \(price), \(timeForPrice)")
        
        try await deleteForUpdate(idEvent: idEvent)
        
        try await insertAll(idEvent: idEvent, name: name, address: address, location: location, info: info, capability: capability, date: date, lists: lists, table: table, price: price, timeForPrice: timeForPrice)
        
        print("Printo i valori: \(name), \(address), \(location), \(info), \(capability), \(date), \(lists), \(table), \(price), \(timeForPrice)")
        
        
        self.updateEvent()
        
    }
    
    func deleteForUpdate(idEvent: String) async throws {
        //reset()
        try await retrieveAllId(id: idEvent)

        try await delete(at: 0)

        self.updateEvent()

    }
    
//    func delete(idEvent: String) async throws {
//        reset()
//        try await retrieveAllId(id: idEvent)
//
//        try await delete(at: 0)
//
//        try await roleModel.deleteCascade(idEvent: idEvent)
//
//        self.updateEvent()
//
//    }
   

    func reset() {
        DispatchQueue.main.async() {
            self.records.removeAll()
            self.event.removeAll()
        }
    }

    func insertEvents(newEvent: Event) async throws {
        var createEvent = Event()
        createEvent.id = UUID().uuidString
        createEvent.name = newEvent.name
        createEvent.address = newEvent.address
        createEvent.location = newEvent.location
        createEvent.info = newEvent.info
        createEvent.capability = newEvent.capability
        createEvent.date = newEvent.date
        createEvent.timeForPrice = newEvent.timeForPrice
        createEvent.price = newEvent.price
        createEvent.table = newEvent.table
        
        do {
            let _ = try await database.save(createEvent.record)

        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createEvent)
        self.updateEvent()
        return
    }
    
    func insertEvent(name: String, address: String, location: String, info: String, capability: Int, date: Date, timeForPrice: [Date], price: [Int], table: [String]) async throws {

        var createEvent = Event()
        createEvent.id = UUID().uuidString
        createEvent.name = name
        createEvent.address = address
        createEvent.location = location
        createEvent.info = info
        createEvent.capability = capability
        createEvent.date = date
        createEvent.timeForPrice = timeForPrice
        createEvent.price = price
        createEvent.table = table
        
        self.eventID = createEvent.id

//        let usrDef = UserDefaults.standard
//        let username = usrDef.value(forKey: "username") as? String ?? "ububgbhgb"
//
//        try await roleModel.insert(username: username, permission: 3, idEvent: createEvent.id)

        do {
            let _ = try await database.save(createEvent.record)

        } catch let error {
            print(error)
            return
        }
        self.insertedObjects.append(createEvent)
        self.updateEvent()
        return
    }
    
    func delete(at index : Int) async throws {
        let recordId = self.event[index].record.recordID
        print("recorddd:: \(recordId)")
        do {
            let _ = try await database.deleteRecord(withID: recordId)
        } catch let error {
            print(error)
            return
        }
        deletedObjectIds.insert(recordId)
        self.updateEvent()
        return
    }
    
    func deleteEvent(at offset : IndexSet) {
        offset.forEach { i in
            let recordId = self.event[i].record.recordID
            Task{
                do {
                    let _ = try await database.deleteRecord(withID: recordId)
                    //roleModel.deleteRole(at: offset)
                } catch let error {
                    print(error)
                    return
                }
                deletedObjectIds.insert(recordId)
            }
        }
        
        event.remove(atOffsets: offset)
//        self.updateEvent()
        
        return
    }
    
    
    private func updateEvent() {
        
        var knownIds = Set(records.map { $0.recordID })
        
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var event = records.map { record in Event(record: record) }
        
        event.append(contentsOf: self.insertedObjects)
        event.removeAll { errand in
            deletedObjectIds.contains(errand.record.recordID)
        }
        
        DispatchQueue.main.async {
            self.event = event
        }
        
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
    
    func loadCoverPhoto(completion: @escaping (_ photo: UIImage?) -> ()) {
        // 1.
        DispatchQueue.global(qos: .utility).async {
            var image: UIImage?
            // 5.
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            // 2.
            guard
                let poster = self.event.first?.poster,
                let fileURL = poster.fileURL
            else {
                return
            }
            let imageData: Data
            do {
                // 3.
                imageData = try Data(contentsOf: fileURL)
            } catch {
                return
            }
            // 4.
            image = UIImage(data: imageData)
        }
    }
    
}

