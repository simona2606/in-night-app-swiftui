//
//  insertPriceView.swift
//  napples
//
//  Created by Gabriele Iorio on 01/06/22.
//

import SwiftUI

struct InsertPriceView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var typology : String = ""
    @State private var priceDescription : String = ""
    @State private var tempPrice: String = ""
    @State private var priceDate = Date()
    @State private var priceTime = Date()
    @State private var priceStartTime = Date()
    
    @Binding var timePrices: [Date]
    @Binding var prices: [Int]
    @Binding var tables: [String]
    
    @State private var selected = 1
 
    @EnvironmentObject var eventModel: EventModel
    
    var body: some View {
        
            ZStack {
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                
                VStack(alignment: .leading , spacing: 20) {
                    
                        Text("Typology")
                            .fontWeight(.bold).font(.system(size: 18)).foregroundColor(.white)
                            .padding(.horizontal)
                        Picker("", selection: $selected) {
                            Text("List").tag(1)
                                .foregroundColor(.white)
                            Text("Table").tag(2)
                                .foregroundColor(.white)
                        }.pickerStyle(.inline)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                   
                    Text("Price")
                        .fontWeight(.bold).font(.system(size: 18)).foregroundColor(.white)
                        .padding(.horizontal)
                    TextField("Price", text: $tempPrice)
                        .padding()
                        .foregroundColor(.white).font(.system(size: 16))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    
                    Text("Time Slot").fontWeight(.bold).font(.system(size: 18)).foregroundColor(.white)
                        .padding(.horizontal)
                    
                    PricePicker(priceStartTime: $priceStartTime)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    
                    Image(systemName: "chevron.backward")
                        .font(Font.subheadline.weight(.bold))
                } )
                .navigationBarItems(trailing: Button(action: {
                    
                    if(selected == 1) {
                        typology = "List"
                    } else if(selected == 2){
                        typology = "Table"
                    }
                    
                    tables.append(typology)
                    prices.append(Int(tempPrice) ?? 99)
                    timePrices.append(priceStartTime)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                        .fontWeight(.bold)
                })
            }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("Prices")
        .navigationBarTitleDisplayMode(.inline)
    }
}





