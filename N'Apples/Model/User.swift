//
//  UserEntity.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import Foundation
import CloudKit

struct User: Identifiable {

    static let recordType = "User"
    fileprivate static let keyId = "id"
    fileprivate static let keyUsername = "username"
    fileprivate static let keyPassword = "password"
    fileprivate static let keyEmail = "email"
    fileprivate static let keyPhoto = "photo"
    
    var record : CKRecord

    init(record : CKRecord) {
        self.record = record
    }

    init() {
        self.record = CKRecord(recordType: User.recordType)
    }
    
    var id : String {
        get {
            return self.record.value(forKey: User.keyId) as! String
        }
        set {
            self.record.setValue(newValue, forKey: User.keyId)
        }
    }

    var username : String {
        get {
            return self.record.value(forKey: User.keyUsername) as! String
        }
        set {
            self.record.setValue(newValue, forKey: User.keyUsername)
        }
    }
    
    var password : String {
        get {
            return self.record.value(forKey: User.keyPassword) as! String
        }
        set {
            self.record.setValue(newValue, forKey: User.keyPassword)
        }
    }
    
    var email : String {
        get {
            return self.record.value(forKey: User.keyEmail) as! String
        }
        set {
            self.record.setValue(newValue, forKey: User.keyEmail)
        }
    }
    
    var photo : CKAsset {
        get {
            return self.record.value(forKey: User.keyPhoto) as! CKAsset
        }
        set {
            self.record.setValue(newValue, forKey: User.keyPhoto)
        }
    }

}
