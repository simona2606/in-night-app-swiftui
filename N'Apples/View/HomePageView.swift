//
//  HomePage.swift
//  N'Apples
//
//  Created by Simona Ettari on 19/05/22.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    @State var presentLogin: Bool = false
    @State var presentReservation: Bool = false
    @State var nameEvent: String = ""
    @State var presenteAlert: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                VStack (spacing: 100) {
                    NavigationLink(destination: LoginView(), isActive: $presentLogin) {
                        Text("Go to Login View")
                            .onTapGesture {
                                presentLogin.toggle()
                            }
                    }
                    
                    TextField("Name Event", text: $nameEvent)
                    
                    NavigationLink(destination: ReservationView(), isActive: $presentReservation) {
                        Text("Search Event")
                            .onTapGesture {
                                Task {
                                    print("Name event prima del retrive: \(nameEvent)")
                                    try await eventModel.retrieveAllName(name: nameEvent)
                                    
                                    if (nameEvent != eventModel.event.first?.name) {
                                        eventModel.event.removeAll()
                                        print("ModelCount in if \(eventModel.event.count)")
                                    }
                                    
                                    print("Name event: \(nameEvent)")
                                    print("Model count \(eventModel.event.count)")
                                    
                                    if (!eventModel.event.isEmpty) {
                                        presentReservation = true
                                    } else {
                                        presentReservation = false
                                        presenteAlert.toggle()
                                        print ("Vuoto")
                                    }
                                }
                            }
                    }
                }
                
                if (presenteAlert == true) {
                    AlertError(show: $presenteAlert)
                }
            }
            .navigationTitle("My Events")
        }
    }
    
}
