//
//  ReservationView.swift
//  N'Apples
//
//  Created by Simona Ettari on 21/12/22.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ReservationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reservationViewModel: ReservationModel
    @ObservedObject var updateEventViewModel: UpdateEventViewModel
    
    @State var name: String = ""
    @State var surname: String = ""
    @State var email: String = ""
    @State var nameList: String = ""
    @State var numFriends: String = ""
    @State var qrNumber = UUID()
    @State var show = false
    @State var showqr: Bool = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        TextField("Name", text: $name)
                            .padding()
                            .foregroundColor(.white).font(.system(size: 16))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                            .padding(.top, 20)
                        
                        TextField("Surname", text: $surname)
                            .padding()
                            .foregroundColor(.white).font(.system(size: 16))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .foregroundColor(.white).font(.system(size: 16))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                        
                        TextField("Name List", text: $nameList)
                            .padding()
                            .foregroundColor(.white).font(.system(size: 16))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                        
                        TextField("Friends number", text: $numFriends)
                            .padding()
                            .foregroundColor(.white).font(.system(size: 16))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                            ).padding(.horizontal)
                    }.padding(.bottom)
                    
                    VStack(alignment: .center) {
                        let qrImage = generateQRCode(from: "\(qrNumber)")
                        let image = Image(uiImage: qrImage)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        if(showqr) {
                            image
                                .onLongPressGesture {
                                    show.toggle()
                                    let imageSaved = ImageSaved()
                                    imageSaved.writeToPhotoAlbum(image: qrImage)
                                }
                        }
                    }.padding(.bottom)
                }
            }
            .navigationTitle(Text("New Guest"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").fontWeight(.bold)
            },trailing: Button(action: {
                Task {
                    try await reservationViewModel.insert(event: updateEventViewModel.eventID, id: qrNumber.uuidString, name: name, surname: surname, email: email, nameList: nameList, numFriends: Int(numFriends) ?? 0)
                    showqr = true
                    
                }
                
            }) {
                Text("Add").fontWeight(.bold)
            })
        }
        
        if (show) {
            Alert(show: $show)
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}

