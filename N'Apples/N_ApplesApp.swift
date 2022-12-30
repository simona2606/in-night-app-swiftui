//
//  N_ApplesApp.swift
//  N'Apples
//
//  Created by Simona Ettari on 07/05/22.
//

import SwiftUI

@main
struct N_ApplesApp: App {
    @ObservedObject var userSettings = UserSettings()
    @StateObject var userModel = UserModel()
    @StateObject var eventModel = EventModel()
    @StateObject var roleModel = RoleModel()
    @StateObject var reservationModel = ReservationModel()

    var body: some Scene {
        WindowGroup {
            if userSettings.id == "" {
                RegistrationView()
                    .environmentObject(userModel)
                    .environmentObject(eventModel)
                    .environmentObject(roleModel)
                    .environmentObject(reservationModel)

            } else {
                EventsView()
                    .environmentObject(userModel)
                    .environmentObject(eventModel)
                    .environmentObject(roleModel)
                    .environmentObject(reservationModel)
            }
        }
    }
}
