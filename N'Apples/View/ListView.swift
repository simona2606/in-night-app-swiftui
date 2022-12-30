//
//  ListView.swift
//  N'Apples
//
//  Created by Simona Ettari on 21/12/22.
//

import SwiftUI

struct ListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var reservationViewModel: ReservationModel
    @ObservedObject var updateEventViewModel: UpdateEventViewModel
    @ObservedObject var eventViewModel: EventModel
    
    @State private var selected = 0
    @State private var totalNumFriends = 0
    @State private var totalName = 0
    @State private var total = 0
    @State private var tot = 0
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .leading){
                Image (uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack (alignment: .leading, spacing: 10) {
                        
                        Picker("", selection: $selected) {
                            Text("Entry").tag(0)
                            Text("Entry with friends").tag(1)
                        }.pickerStyle(.segmented)
                            .padding(.horizontal, 30)
                        
                        if (selected == 0) {
                            Text("Names")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Color(.white))
                                .padding(.horizontal, 30)
                                .padding(.bottom, 25)
                                .padding(.top, 20)
                        } else if (selected == 1) {
                            HStack {
                                Text("Names")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(.white))
                                Spacer()
                                Text("Numbers")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(.white))
                            }.padding(.horizontal, 30)
                                .padding(.bottom, 25)
                                .padding(.top, 20)
                        }
                        
                        ForEach(reservationViewModel.reservation) { reservation in
                            if (selected == 0 && reservation.numFriends == 0) {
                                Text(reservation.name)
                                    .font(.callout)
                                    .foregroundColor(Color(.white))
                                    .padding(.horizontal, 30)
                                Divider()
                                    .onAppear {
                                        tot += 1
                                    }
                                
                            } else if (selected == 1 && reservation.numFriends != 0){
                                HStack {
                                    Text(reservation.name)
                                        .font(.callout)
                                        .foregroundColor(Color(.white))
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5).frame(width: 50, height: 25)
                                            .foregroundColor(Color(UIColor(named: "Pink")!))
                                        Text("+ \(reservation.numFriends)")
                                            .font(.callout)
                                            .bold()
                                            .foregroundColor(Color(.white))
                                        
                                    }
                                }.padding(.horizontal, 30)
                                    .onAppear {
                                        totalNumFriends = totalNumFriends + reservation.numFriends
                                        if (!reservation.name.isEmpty) {
                                            totalName += 1
                                        }
                                        
                                    }
                                Divider()
                            }
                        }
                        
                        HStack {
                            Spacer()
                            if (selected == 0) {
                                Text("Total: \(tot) people")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 40)
                            } else if (selected == 1) {
                                Text("Total: \(totalNumFriends+totalName) people")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 40)
                            }
                            Spacer()
                        }
                    }
                }
            }
            
            .navigationTitle(Text("Reservation"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").fontWeight(.bold)
            })
            
        }.onAppear {
            Task {
                try await reservationViewModel.retrieveAllEventIdDecrypt(idEvent: updateEventViewModel.eventID)
            }
        }
        .navigationBarHidden(true)
    }
}

