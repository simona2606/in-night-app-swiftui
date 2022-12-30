//
//  UserEntity.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit

struct Role {
    
    static let recordType = "Role"
    fileprivate static let keyIdEvent = "idEvent"
    fileprivate static let keyUsername = "username"
    fileprivate static let keyPermission = "permission"

    var record : CKRecord

    init(record : CKRecord) {
        self.record = record
    }

    init() {
        self.record = CKRecord(recordType: Role.recordType)
    }
    
    var idEvent : String {
        get {
            return self.record.value(forKey: Role.keyIdEvent) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Role.keyIdEvent)
        }
    }

    var username : String {
        get {
            return self.record.value(forKey: Role.keyUsername) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Role.keyUsername)
        }
    }
    
    var permission : [Int] {
        get {
            return self.record.value(forKey: Role.keyPermission) as! [Int]
        }
        set {
            self.record.setValue(newValue, forKey: Role.keyPermission)
        }
    }

}
