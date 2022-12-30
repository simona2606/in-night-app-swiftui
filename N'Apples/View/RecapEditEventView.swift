//
//  RecapEditEventView.swift
//  N'Apples
//
//  Created by Simona Ettari on 16/12/22.
//

import SwiftUI

struct RecapEditEventView: View {
    @State var pushNotification: CloudkitPushNotificationViewModel = CloudkitPushNotificationViewModel()
    @ObservedObject var updateEventViewModel: UpdateEventViewModel
    @ObservedObject var roleUserViewModel: RoleUserViewModel
    @ObservedObject var eventViewModel: EventModel
    @ObservedObject var roleViewModel: RoleModel
    @ObservedObject var userViewModel: UserModel
    @ObservedObject var viewModel: ScannerViewModel
    @EnvironmentObject var reservationViewModel: ReservationModel
    
    @State private var showingSheet = false
    @State private var showReservation = false
    @State private var showList = false
    @State private var showCamera = false
    @State private var showAddRole = false
    
    @Binding var flagActive: Bool
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text(updateEventViewModel.eventName)
                        .font(.callout)
                        .foregroundColor(.white)
                }.padding(.horizontal, 30)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Location")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text(updateEventViewModel.eventLoaction)
                        .font(.callout)
                        .foregroundColor(.white)
                }.padding(.horizontal, 30)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Capability")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text("\(updateEventViewModel.eventCapability)")
                        .font(.callout)
                        .foregroundColor(.white)
                }.padding(.horizontal, 30)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Date")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                    DatePicker("", selection: $updateEventViewModel.eventDate, displayedComponents: .date)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fixedSize().frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Time")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                    DatePicker("", selection: $updateEventViewModel.eventDate, displayedComponents: .hourAndMinute)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fixedSize().frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Description")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    Text(updateEventViewModel.eventInfo)
                        .font(.callout)
                        .foregroundColor(.white)
                }.padding(.horizontal, 30)
                VStack(alignment: .leading, spacing: 5) {
                    HStack (spacing: 10) {
                        Text("Link Reservation")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        Button(action: {
                            let linkvar = "https://quizcode.altervista.org/API/discorganizer/Reservation.php?idEvent=\(updateEventViewModel.eventID)"
                            UIPasteboard.general.string =  linkvar
                        }, label: {
                            Image(systemName: "doc.on.clipboard")
                                .cornerRadius(5)
                        })
                        
                    }
                    
                    Link(destination: URL(string: "https://quizcode.altervista.org/API/discorganizer/Reservation.php?idEvent=\(updateEventViewModel.eventID)")!, label: {
                        Text("https://inNight.com/Reservation.php?idEvent=\(updateEventViewModel.eventID)")
                            .font(.system(size: 12))
                            .underline()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    })
                    
                }.padding(.horizontal, 30)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Prices")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    
                    if (updateEventViewModel.eventPrice.count > 0) {
                        ForEach(0 ..< updateEventViewModel.eventPrice.count, id: \.self) { int in
                            
                            PriceCardView(orariocard: updateEventViewModel.eventTimeForPrice[int], prezzocard: String(updateEventViewModel.eventPrice[int]), tables: updateEventViewModel.eventTable[int])
                                .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.width * 0.15)
                            
                        }.padding(.vertical, 5)
                            
                    }
                }.padding(.horizontal, 30)
                
            }
        }.background(Image(uiImage: UIImage(named: "sfondo")!).resizable()
            .ignoresSafeArea())
        
        .navigationTitle(Text("Recap"))
        .navigationBarTitleDisplayMode(.inline)
        
        
        .toolbar {
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                if(roleUserViewModel.permission == [0,0,0] || roleUserViewModel.permission == [1,0,0]) {
                    
                    Button(action: {
                        showAddRole.toggle()
                    }, label: {
                        Image(systemName: "person.text.rectangle")
                            .font(.system(size: 16))
                    })
                    
                    Button(action: {
                        showList = true
                    }, label: {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 16))
                    })
                    
                    Button(action: {
                        Task {
                            pushNotification.subscribeEvent(textType: "Event")
                            showingSheet.toggle()
                        }
                        
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                    }
                    
                } else if (roleUserViewModel.permission == [0,0,1]) {
                    Button(action: {
                        showCamera.toggle()
                    }, label: {
                        Image(systemName: "camera")
                            .font(.system(size: 16))
                    })
                } else if (roleUserViewModel.permission == [0,1,0]) {
                    Button(action: {
                        showList = true
                    }, label: {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 16))
                    })
                    
                    Button(action: {
                        showReservation.toggle()
                    }, label: {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 16))
                    })
                    
                }
            }
        }
    
        .sheet(isPresented: $showingSheet, content: {
            EditEventView(updateEventViewModel: updateEventViewModel, flagActive: $flagActive)
        })
        
        .sheet(isPresented: $showReservation, content: {
            ReservationView(updateEventViewModel: updateEventViewModel)
        })
        
        .sheet(isPresented: $showList, content: {
            ListView(reservationViewModel: reservationViewModel, updateEventViewModel: updateEventViewModel, eventViewModel: eventViewModel)
        })
        
        .sheet(isPresented: $showAddRole, content: {
            if #available(iOS 16.0, *) {
                AddRoleView(userViewModel: userViewModel, updateEventViewModel: updateEventViewModel, roleViewModel: roleViewModel)
                    .presentationDetents([.large, .medium, .fraction(0.40)])
            } else {
                
            }
        })
        
        .sheet(isPresented: $showCamera, content: {
            ScannerView(viewModel: viewModel, reservationModel: reservationViewModel)
        })
        
    }
}

