//
//  ScannerView.swift
//  N'Apples
//
//  Created by Simona Ettari on 23/12/22.
//

import SwiftUI

struct ScannerView: View {
    @State var viewModel: ScannerViewModel
    @ObservedObject var reservationModel: ReservationModel
    @State var flagCheck: Bool = false
    @State var flagNotCheck: Bool = false
    @State var numScan = 0
    
    var body: some View {
            NavigationView {
                ZStack {
                    QrCodeScannerView()
                        .found(r: onFoundQrCode(_:))
                        .torchLight(isOn: self.viewModel.torchIsOn)
                        .interval(delay: self.viewModel.scanInterval)
                    
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                        }.padding(.horizontal)
                            .padding(.vertical, 50)
                        
                        Spacer()
                        
                        Text("Keep scanning for QR-codes")
                            .font(.subheadline)
                    }.padding(.bottom, 25)
                    
                }
                
                .ignoresSafeArea(.all)
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.viewModel.torchIsOn.toggle()
                }, label: {
                    VStack {
                        Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                            .padding(7)
                    }.background(Color.white)
                        .cornerRadius(10)
                }))
                
            }

            .sheet(isPresented: $flagCheck, content: {
                ValidTicket(reservationModel: reservationModel, viewModel: $viewModel)
            })
        
            .sheet(isPresented: $flagNotCheck, content: {
                InvalidTicket()
            })
    }
    
    func onFoundQrCode(_ code: String) {
            Task {
                reservationModel.records.removeAll()
                reservationModel.reservation.removeAll()
                viewModel.lastQrCode.removeAll()
                viewModel.lastQrCode = code

                try await reservationModel.updateNumScan(id: viewModel.lastQrCode, numscan: numScan)
                print("Reservation: \(reservationModel.reservation)")
                print("Value qr: \(viewModel.lastQrCode)")
                
                if(!reservationModel.reservation.isEmpty) {
                    flagCheck.toggle()
                    print("Valid: \(flagCheck)")
                    
                } else {
                    flagNotCheck.toggle()
                    print("Not valid: \(flagNotCheck)")
                }
                
                
                
            }
    }
    
}
