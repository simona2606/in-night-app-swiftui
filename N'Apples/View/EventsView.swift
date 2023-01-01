//
//  EventsView.swift
//  N'Apples
//
//  Created by Simona Ettari on 14/12/22.
//

import SwiftUI

struct EventsView: View {
    @State var modal: ModalType? = nil
    @State var indici: [Int] = []
    
    @State var pushNotification: CloudkitPushNotificationViewModel = CloudkitPushNotificationViewModel()
    
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var viewModel = ScannerViewModel()
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var roleModel: RoleModel
    @EnvironmentObject var reservationModel: ReservationModel
    
    @State var flagActive = false
    @State var showRecap: Bool = false
    @State var alertDelEvent: Bool = false
    
    @State var tmpPermission: [Int] = []
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        NavigationView {
            
            if #available(iOS 16.0, *) {
                
                ZStack {
                    Image(uiImage: UIImage(named: "sfondo")!).resizable()
                        .ignoresSafeArea()
                    List {
                        ForEach(eventModel.event) { event in
                            ZStack (alignment: .leading) {

                                HStack {
                                    Image(uiImage: UIImage(named: "mirrorball")!).padding(.horizontal, -11)
                                        
                                    VStack (alignment: .leading, spacing: 8) {
                                        Text(event.name)
                                            .font(.headline)
                                            .foregroundColor(Color(UIColor(named: "AccentColor")!))
                                        HStack {
                                            Image(systemName: "mappin.and.ellipse")
                                            Text(event.location)
                                        } .font(.callout)
                                            .foregroundColor(Color(.black))
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text("\(formattedDate(date: event.date, format: "dd/MM" )) ")
                                        } .font(.callout)
                                            .foregroundColor(Color(.black))
                                        HStack {
                                            Image(systemName: "clock")
                                            Text("\(formattedDate(date: event.date, format: "HH:mm" )) ")
                                        } .font(.callout)
                                        .foregroundColor(Color(.black))
                                        
                                    }.padding(.horizontal, 10)
                                }.listRowSeparator(.hidden)
                                
                            
                                if(!userModel.user.isEmpty && !roleModel.role.isEmpty) {
                                    
                                    NavigationLink("", destination: RecapEditEventView(updateEventViewModel: UpdateEventViewModel(currentUser: userModel.user.first!, currentEvent: event), roleUserViewModel: RoleUserViewModel(currentEvent: event, currentRole: roleModel.role.first!), eventViewModel: eventModel, roleViewModel: roleModel, userViewModel: userModel, viewModel: viewModel, flagActive: $flagActive))
                                        .frame(width: 0, height: 0)
                                        .opacity(0)
                                }
                            }.listRowBackground(Image(uiImage: UIImage(named: "Card")!))
                            .padding(-10)
                        }.onDelete(perform: self.delete)
                            .padding(.vertical, 10)
                            .listRowSeparator(.hidden)
                    }.listStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    .navigationTitle(Text("Events"))
                    .navigationBarTitleDisplayMode(.inline)
                    
                    
                    .navigationBarItems(leading:
                                            NavigationLink(destination: RegistrationView(), label: {
                        Label("Profile", systemImage: "rectangle.portrait.and.arrow.right").rotationEffect(.degrees(180)).font(.system(size: 15))
                    }))
                    
//                    .toolbarBackground(Color(.black), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    
                    .toolbar {
                        Button {
                            showRecap.toggle()
                        } label: {
                            Label("Add Event", systemImage: "plus.circle")
                        }
                    }
                }
                
            } else {
                
            }
        }
        
        .navigationBarHidden(true)
        
        .sheet(isPresented: $showRecap, content: {
            CreateEventView(userSettings: userSettings)
        })
        
        .onAppear {
            pushNotification.requestNotificationPermission()
            Task {
                do {
                    print("User settings: \(userSettings.id)")
                    try await userModel.retrieveAllName(username: userSettings.id)
                    print("Current user: \(String(describing: userModel.user.first?.username))")
                    
                    if (!userModel.user.isEmpty) {
                        var tmp = Role()
                        roleModel.reset()
                        eventModel.reset()
                        
                        try await roleModel.retrieveAllUsername(username: userModel.user.first?.username ?? "")
                        for i in 0 ..< roleModel.role.count {
                            tmpPermission = roleModel.role[i].permission
                            tmp = roleModel.role[i]
                            try await eventModel.retrieveAllId(id: tmp.idEvent)
                            
                        }
                    }
                    print("My Events: \(eventModel.event)")
                }
                catch {
                    print("❌ Error: \(error)")
                }
            }
            
        }
        if(alertDelEvent) {
            AlertDelEvent(alertDelEvent: $alertDelEvent)
        }
        
    }
    
    func formattedDate(date: Date, format: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.string(from: date)
    }
    
    func delete(at offset : IndexSet) {
        if(tmpPermission == [0,0,0] || tmpPermission == [1,0,0]) {
            eventModel.deleteEvent(at: offset)
            roleModel.deleteRole(at: offset)
        } else {
            alertDelEvent.toggle()
        }
    }
    
}

