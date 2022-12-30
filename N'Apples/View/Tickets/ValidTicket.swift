//
//  ValidTicket.swift
//  N'Apples
//
//  Created by Simona Ettari on 23/12/22.
//

import SwiftUI

struct ValidTicket: View {
    
    @ObservedObject var reservationModel: ReservationModel
    @Binding var viewModel: ScannerViewModel
    @State var numScan: Int = 0
    @State var disable = false
    @State var nome = ""
    @State var cognome = ""
    @State var email = ""
    @State var numFriends = 0
    @State var list = ""
    
    var body: some View {
        
        ZStack {
            GeometryReader{ geometry in
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                VStack(spacing: 50) {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Text("Valid Ticket")
                                .foregroundColor(Color(UIColor(named: "ValidGreen")!))
                                .underline()
                                .bold()
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                            
                            Spacer()
                        }
                        
                        Image("valid")
                            .frame(width: geometry.size.width*0.5)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Booked by")
                            .underline()
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                            
                        Text("\(nome)  \(cognome )")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                        
                        Text("N° of people invited")
                            .underline()
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                        
                        if(numScan != numFriends) {
                            Text("\( numScan)/\(numFriends )")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                        } else if(numScan == numFriends) {
                            Text("\( numScan)/\(numFriends )")
                                .font(.callout)
                                .foregroundColor(.red)
                                .padding(.horizontal, 30)
                        }
                        
                        Text("Promoter")
                            .underline()
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                        Text("\(list)")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                        
                        Text("E-mail")
                            .underline()
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                        Text("\(email)")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 50)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                Task {
                                    if (numScan < numFriends) {
                                        numScan = numScan + 1
                                        try await reservationModel.updateNumScan(id: viewModel.lastQrCode, numscan: numScan)
                                        print("NumScan: \(numScan)")
                                    } else {
                                        disable = true
                                    }
       
                                }

                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(Color.orange)
                                        .frame(width: 150, height: 50, alignment: .center)
                                    Text("Add Ingress")
                                        .font(.callout)
                                        .bold()
                                        .foregroundColor(Color.white)
                                }
                                
                            }.disabled(disable)
                            Spacer()
                        }
                    }
                    
                    
                }
            }
        }.onAppear {
            numScan = reservationModel.reservation.first!.numScan
            nome = reservationModel.reservation.first!.name
            cognome = reservationModel.reservation.first!.surname
            email = reservationModel.reservation.first!.email
            numFriends = reservationModel.reservation.first!.numFriends
            list = reservationModel.reservation.first!.nameList
        }
        
    }
}


