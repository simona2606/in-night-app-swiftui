//
//  CreateEventView.swift
//  N'Apples
//
//  Created by Simona Ettari on 15/12/22.
//

import SwiftUI

struct CreateEventView: View {
    
    @State var pushNotification: CloudkitPushNotificationViewModel = CloudkitPushNotificationViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userSettings: UserSettings
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var roleModel: RoleModel
    
    @State var nameEvent: String = ""
    @State var location: String = ""
    @State var address: String = ""
    @State var info: String = ""
    @State var capability: String = ""
    @State var dateEvents: Date = Date()
    @State var timePrices: [Date] = []
    @State var prices: [Int] = []
    @State var tempPrices: [String] = []
    @State var tables: [String] = []
    @State var openAlert: Bool = false
    @State var ind: Int = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack (spacing: 20) {
                        TextField("Event name", text: $nameEvent)
                            .foregroundColor(.white).font(.system(size: 16))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.top, 40)
                            .padding(.horizontal)
                        
                        TextField("Location", text: $location)
                            .foregroundColor(.white).font(.system(size: 16))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                        
                        TextField("Capability", text: $capability)
                            .foregroundColor(.white).font(.system(size: 16))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                                VStack {
                                    HStack {
                                        Text("Date").foregroundColor(.white)
                                        DatePicker("", selection: $dateEvents, displayedComponents: .date)
                                    }
                                    
                                    Divider().foregroundColor(.white)
                                    HStack {
                                        Text("Time").foregroundColor(.white)
                                        DatePicker("", selection: $dateEvents, displayedComponents: .hourAndMinute)
                                    }
                                    
                                }.padding()
                          
                        }.padding(.horizontal)
                        
                        TextField("Event description", text: $info)
                            .foregroundColor(.white).font(.system(size: 16))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                            .padding(.bottom)
                        
                        Divider()
                        HStack (spacing: 20) {
                            
                            Text("Prices")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            NavigationLink(destination: InsertPriceView(timePrices: $timePrices, prices: $prices, tables: $tables)) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                            
                        }.padding(.horizontal)
                        
                        if tables.count > 0 {
                            ForEach(0 ..< tables.count, id: \.self) { int in
                                
                                PriceCardView(orariocard: timePrices[int], prezzocard: String(prices[int]), tables: tables[int])
                                    .onLongPressGesture {
                                        ind = int
                                        tempPrices = prices.map{String($0)}
                                        openAlert.toggle()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.width * 0.15)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Create Event"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").fontWeight(.bold)
            } ,trailing: Button(action: {
                Task {
                    pushNotification.subscribeEvent(textType: "Event")
                    try await eventModel.insertEvent(name: nameEvent, address: address, location: location, info: info, capability: Int(capability) ?? 0, date: dateEvents, timeForPrice: timePrices, price: prices.map{Int($0) }, table: tables.map{String($0)})
                    try await roleModel.insert(username: userSettings.id, permission: 3, idEvent: eventModel.eventID!)
                    presentationMode.wrappedValue.dismiss()
                }
                
            }) {
                Text("Save").fontWeight(.bold)
                
                if(openAlert) {
                    AlertCancelPrice(show: $openAlert, timePrices: $timePrices, prices: $prices, tables: $tables, ind: $ind)
                }
                
            } )
            
        }
    }
    
}


