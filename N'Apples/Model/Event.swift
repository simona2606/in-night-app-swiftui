//
//  EventEntity.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit

struct Event: Identifiable { 

    static let recordType = "Event"
    fileprivate static let keyId = "id"
    fileprivate static let keyName = "name"
    fileprivate static let keyAddress = "address"
    fileprivate static let keyLocation = "location"
    fileprivate static let keyInfo = "info"
    fileprivate static let keyPoster = "poster"
    fileprivate static let keyCapability = "capability"
    fileprivate static let keyDate = "date"
    fileprivate static let keyLists = "lists"
    fileprivate static let keyTable = "table"
    fileprivate static let keyPrice = "price"
    fileprivate static let keyTimezone = "timezone"

    var record : CKRecord

    init(record : CKRecord) {
        self.record = record
    }

    init() {
        self.record = CKRecord(recordType: Event.recordType)
    }
    
    var id : String {
        get {
            return self.record.value(forKey: Event.keyId) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyId)
        }
    }

    var name : String {
        get {
            return self.record.value(forKey: Event.keyName) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyName)
        }
    }
    
    var address : String {
        get {
            return self.record.value(forKey: Event.keyAddress) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyAddress)
        }
    }
    
    var location : String {
        get {
            return self.record.value(forKey: Event.keyLocation) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyLocation)
        }
    }
    
    var info : String {
        get {
            return self.record.value(forKey: Event.keyInfo) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyInfo)
        }
    }
    
    var poster : CKAsset {
        get {
            return self.record.value(forKey: Event.keyPoster) as! CKAsset
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyPoster)
        }
    }
    
    var capability : Int {
        get {
            return self.record.value(forKey: Event.keyCapability) as! Int
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyCapability)
        }
    }
    
    var date : Date {
        get {
            return self.record.value(forKey: Event.keyDate) as! Date
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyDate)
        }
    }
    
    var lists : [String] {
        get {
            return self.record.value(forKey: Event.keyLists) as? [String] ?? [""]
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyLists)
        }
    }
    
    var table : [String] {
        get {
            return self.record.value(forKey: Event.keyTable) as! [String]
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyTable)
        }
    }
    
    var price : [Int] {
        get {
            return self.record.value(forKey: Event.keyPrice) as! [Int]
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyPrice)
        }
    }
    
    var timeForPrice : [Date] {
        get {
            return self.record.value(forKey: Event.keyTimezone) as! [Date]
        }
        set {
            self.record.setValue(newValue, forKey: Event.keyTimezone)
        }
    }

}
