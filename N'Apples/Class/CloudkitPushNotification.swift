//
//  CloudkitPushNotification.swift
//  N'Apples
//
//  Created by Simona Ettari on 17/05/22.
//

import Foundation
import SwiftUI
import CloudKit

class CloudkitPushNotificationViewModel: ObservableObject{
    
    func requestNotificationPermission(){
        let options:UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler:
                                                                    { succes,error in
            if let error = error {
                print(error)
            } else if succes {
                print("Notification permission succes")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else{
                print("Notification Permission failure")
            }
        })
    }
    
    func fetchRecord(_ recordID: CKRecord.ID) -> Void {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID,
                         completionHandler: ({record, error in
            if error != nil {
                DispatchQueue.main.async() {
                    print("Fetch Error")
                }
            } else {
             
                }
            }
        ))
    }
    
    func subscribeEvent(textType: String) {
        let predicate = NSPredicate (value: true)
        let subscription = CKQuerySubscription(recordType: textType, predicate: predicate, subscriptionID: "event_added_to_database", options: .firesOnRecordCreation)
        let notification = CKSubscription.NotificationInfo()
       
        notification.title = "There's a new Event"
        notification.alertBody = "Open the app to join"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        CKContainer.default().publicCloudDatabase.save(subscription){ returnedSubscription,returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Success subscribed to notification")
            }
        }
    }
    
    func subscribe(textType: String, userName: String) {

        let predicate = NSPredicate(format: "content CONTAINS[c] %@", "userName")
//        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["recipient", userName])
        let subscription = CKQuerySubscription(recordType: textType, predicate: predicate, options: .firesOnRecordCreation)
       
        let subscription1 = CKQuerySubscription(recordType: textType, predicate: predicate, subscriptionID: "event_added_to_database", options: .firesOnRecordDeletion)
  
        let notification = CKSubscription.NotificationInfo()
       
        notification.title = "You have been assigned to a new role \(userName)"
        notification.alertBody = "Open the app to view this"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        subscription1.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription){ returnedSubscription,returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Success subscribed to notification")
            }
        }
    }
    
    func unsubscribe(userName: String) {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: userName) {
            returnedId,returnedError in
            if let error = returnedError{
                print(error)
            }else{
                print("Success unsubscribed to notification")
            }
            
        }
    }
}



