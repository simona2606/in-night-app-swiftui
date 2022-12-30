//
//  ReservationEntity.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit

struct Reservation: Identifiable, Hashable {

    static let recordType = "Reservation"
    fileprivate static let keyId = "id"
    fileprivate static let keyName = "name"
    fileprivate static let keySurname = "surname"
    fileprivate static let keyEmail = "email"
    fileprivate static let keyNameList = "nameList"
    fileprivate static let keyTimeScan = "timeScan"
    fileprivate static let keyNumFriends = "numFriends"
    fileprivate static let keyNumScan = "numScan"
    fileprivate static let keyIdEvent = "idEvent"

    
    var record : CKRecord

    init(record : CKRecord) {
        self.record = record
    }

    init() {
        self.record = CKRecord(recordType: Reservation.recordType)
    }
    
    var id : String {
        get {
            return self.record.value(forKey: Reservation.keyId) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyId)
        }
    }

    var name : String {
        get {
            return self.record.value(forKey: Reservation.keyName) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyName)
        }
    }
    
    var surname : String {
        get {
            return self.record.value(forKey: Reservation.keySurname) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keySurname)
        }
    }
    
    var email : String {
        get {
            return self.record.value(forKey: Reservation.keyEmail) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyEmail)
        }
    }
    
    var nameList : String {
        get {
            return self.record.value(forKey: Reservation.keyNameList) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyNameList)
        }
    }
    
    var timeScan : [Date] {
        get {
            return self.record.value(forKey: Reservation.keyTimeScan) as! [Date]
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyTimeScan)
        }
    }
    
    var numFriends : Int {
        get {
            return self.record.value(forKey: Reservation.keyNumFriends) as! Int
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyNumFriends)
        }
    }
    
    var numScan : Int {
        get {
            return self.record.value(forKey: Reservation.keyNumScan) as! Int
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyNumScan)
        }
    }
    
    var idEvent : String {
        get {
            return self.record.value(forKey: Reservation.keyIdEvent) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Reservation.keyIdEvent)
        }
    }

}

