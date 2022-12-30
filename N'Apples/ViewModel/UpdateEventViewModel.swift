//
//  UpdateEventViewModel.swift
//  N'Apples
//
//  Created by Simona Ettari on 17/12/22.
//

import Foundation

final class UpdateEventViewModel: ObservableObject {
    
    var userID: String
    var eventID: String
    var eventName: String
    var eventLoaction: String
    var eventCapability: Int
    var eventDate: Date
    var eventInfo: String
    var eventTable: [String]
    var eventPrice: [Int]
    var eventTimeForPrice: [Date]
    var eventAddress: String
    var eventLists: [String]

    init(currentUser: User, currentEvent: Event) {
        self.userID = currentUser.id
        self.eventID = currentEvent.id
        self.eventName = currentEvent.name
        self.eventLoaction = currentEvent.location
        self.eventCapability = currentEvent.capability
        self.eventDate = currentEvent.date
        self.eventInfo = currentEvent.info
        self.eventTable = currentEvent.table
        self.eventPrice = currentEvent.price
        self.eventTimeForPrice = currentEvent.timeForPrice
        self.eventAddress = currentEvent.address
        self.eventLists = currentEvent.lists
    }
    
}
