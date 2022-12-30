////
////  priceRecap.swift
////  N'Apples
////
////  Created by Simona Ettari on 13/06/22.
////
//
//import Foundation
//import SwiftUI
//
//struct priceRecap: View {
//    
//    @Binding var titolocard : String
//    @Binding var costoprezzobin : [String]
////    @State var titoloPrezzo : String = ""
//    @State var descrizionePrezzo : String = ""
////    @State var costoPrezzo : String = ""
//   
//    @Binding var birthDate: Date
//    
//    var body: some View {
//        
//            
//        
//            GeometryReader{geometry in
//                
//                ZStack{
//                    
//                    Color(red: 11/255, green: 41/255, blue: 111/255)
//                        .ignoresSafeArea()
//                    
//                   
//                        VStack(alignment: .leading, spacing: 30){
//
//                            
//                            
//                        TextField("Price title", text: $titolocard)
//                            .foregroundColor(.white).font(.system(size: 21))
//                            .padding()
//                            .overlay(RoundedRectangle(cornerRadius: 14)
//                                        .stroke(Color.white, lineWidth: 3)
//                            )
//                        
//                        
//                        TextField("Price description", text: $descrizionePrezzo)
//                            .foregroundColor(.white).font(.system(size: 21))
//                            .padding()
//                            .overlay(RoundedRectangle(cornerRadius: 14)
//                                        .stroke(Color.white, lineWidth: 3)
//                                     
//                            )
//                        
//                        
//                        TextField("Event name", text: $costoprezzobin[0])
//                            .foregroundColor(.white).font(.system(size: 21))
//                            .padding()
//                            .overlay(RoundedRectangle(cornerRadius: 14)
//                                        .stroke(Color.white, lineWidth: 3)
//                            )
////                            .frame(width: geometry.size.width*0.4)
//                        
//                            
//                            
//                            
//                        Text("Time slot")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .font(.title)
//                        
//                            PickersView(birthDate: $birthDate)
//                            Spacer()
//                                .padding(.vertical,80)
//                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
//                                Text("Cancel price")
//                                    .font(.system(size: 22))
//                                    .foregroundColor(.red)
//                                    .fontWeight(.semibold)
//                                    .underline()
//                            }
//                            .padding(.leading,140)
//                            
//                          
//                            
//                        
//                    }
//                        .frame(width: geometry.size.width*0.93, height: geometry.size.height*0.1)
//                     
//                    
//            }
//        
//    }
//            .ignoresSafeArea(.keyboard, edges: .bottom)
//            .navigationTitle("Details")
//            .navigationBarTitleDisplayMode(.inline)
//}
//}
