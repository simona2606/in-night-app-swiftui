//
//  EditEventView.swift
//  N'Apples
//
//  Created by Simona Ettari on 17/12/22.
//

import SwiftUI

struct EditEventView: View {
    
    @State var pushNotification: CloudkitPushNotificationViewModel = CloudkitPushNotificationViewModel()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var updateEventViewModel: UpdateEventViewModel
    
    @EnvironmentObject var eventModel: EventModel
    
    @State var capability: String = ""
    @State var dateEvents: Date = Date()
    @State var timePrices: [Date] = []
    @State var timePricesEnd: [Date] = []
    @State var tables: [String] = []
    @State var openAlert: Bool = false
    @State var ind: Int = 0
    
    @Binding var flagActive: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack (spacing: 20) {
                        VStack (alignment: .leading, spacing: 5) {
                            Text("Name").foregroundColor(.white)
                            TextField("\(updateEventViewModel.eventName)", text: $updateEventViewModel.eventName)
                                .foregroundColor(.white)
                                .font(.callout)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                                )
                        }.padding(.horizontal)
                        
                        VStack (alignment: .leading, spacing: 5) {
                            Text("Location").foregroundColor(.white)
                            TextField("\(updateEventViewModel.eventLoaction)", text: $updateEventViewModel.eventLoaction)
                                .foregroundColor(.white)
                                .font(.callout)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                                )
                        }.padding(.horizontal)
                        
                        VStack (alignment: .leading, spacing: 5) {
                            Text("Capability").foregroundColor(.white)
                            TextField("\(updateEventViewModel.eventCapability)", text: $capability)
                                .onAppear {
                                    capability = String(updateEventViewModel.eventCapability)
                                }
                                .foregroundColor(.white)
                                .font(.callout)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                                )
                        }.padding(.horizontal)
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            
                            VStack (alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("Date").foregroundColor(.white)
                                    DatePicker("", selection: $updateEventViewModel.eventDate, displayedComponents: .date)
                                }
                                
                                Divider().foregroundColor(.white)
                                HStack {
                                    Text("Time").foregroundColor(.white)
                                    DatePicker("", selection: $updateEventViewModel.eventDate, displayedComponents: .hourAndMinute)
                                }
                                
                            }.padding()
                            
                        }.padding(.horizontal)
                        
                        VStack (alignment: .leading, spacing: 5) {
                            Text("Info").foregroundColor(.white)
                            TextField("\(updateEventViewModel.eventInfo)", text: $updateEventViewModel.eventInfo)
                                .foregroundColor(.white)
                                .font(.callout)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                                )
                        }.padding(.horizontal)
                            .padding(.bottom)
                        
                        Divider()
                        HStack (spacing: 20) {
                            
                            Text("Prices")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            NavigationLink(destination: InsertPriceView(timePrices: $updateEventViewModel.eventTimeForPrice, prices: $updateEventViewModel.eventPrice, tables: $updateEventViewModel.eventTable)) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.orange)
                            }
                            
                            Spacer()
                            
                        }.padding(.horizontal)
                        
                        if (updateEventViewModel.eventTable.count > 0) {
                            ForEach(0 ..< updateEventViewModel.eventTable.count, id: \.self) { int in
                                PriceCardView(orariocard: updateEventViewModel.eventTimeForPrice[int], prezzocard: String(updateEventViewModel.eventPrice[int]), tables: updateEventViewModel.eventTable[int])
                                    .onLongPressGesture {
                                        ind = int
                                        openAlert.toggle()
                                        print("int: \(int)")
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.width * 0.15)
                            }
                            
                        }
                    }.padding()
                }
            }
            .navigationTitle(Text("Edit Event"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").fontWeight(.bold)
            } ,trailing: Button(action: {
                Task {
                    pushNotification.subscribeEvent(textType: "Event")
                    try await eventModel.update(idEvent: updateEventViewModel.eventID, name: updateEventViewModel.eventName, address: updateEventViewModel.eventAddress, location: updateEventViewModel.eventLoaction, info: updateEventViewModel.eventInfo, capability: Int(capability) ?? 0, date: updateEventViewModel.eventDate, lists: updateEventViewModel.eventLists, table: updateEventViewModel.eventTable.map{String($0)}, price: updateEventViewModel.eventPrice, timeForPrice: updateEventViewModel.eventTimeForPrice)
                    flagActive = false
                    presentationMode.wrappedValue.dismiss()
                    
                }
                
            }) {
                Text("Save").fontWeight(.bold)
                
            } )
            
            if(openAlert) {
                AlertCancelPrice(show: $openAlert, timePrices: $updateEventViewModel.eventTimeForPrice, prices: $updateEventViewModel.eventPrice, tables: $updateEventViewModel.eventTable, ind: $ind)
            }
            
        }
        .navigationBarHidden(true)
    }
}

