//
//  RoleUserViewModel.swift
//  N'Apples
//
//  Created by Simona Ettari on 21/12/22.
//

import Foundation

final class RoleUserViewModel: ObservableObject {
    
    var eventID: String
    var eventName: String
    var userName: String
    var permission: [Int]

    init(currentEvent: Event, currentRole: Role) {
        self.eventID = currentEvent.id
        self.eventName = currentEvent.name
        self.permission = currentRole.permission
        self.userName = currentRole.username
    }
    
}
