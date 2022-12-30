//
//  AddRoleView.swift
//  N'Apples
//
//  Created by Simona Ettari on 21/12/22.
//

import SwiftUI

struct AddRoleView: View {
    
    @State var pushNotification: CloudkitPushNotificationViewModel = CloudkitPushNotificationViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userViewModel: UserModel
    @ObservedObject var updateEventViewModel: UpdateEventViewModel
    @State var roleViewModel = RoleModel()
    @State var userSeacrh: String = ""
    @State var showingAlertRole: Bool = false
    @State var activatePicker: Bool = false
    @State var selectedRole = 0
    @State private var showPopUp = false
    @State  var permission: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 50) {
                    VStack (alignment: .leading, spacing: 18) {
                        Text("Write the email of your collaborators")
                            .font(.callout)
                            .padding(.top)
                        
                        TextField("", text: $userSeacrh)
                            .placeholder(when: userSeacrh.isEmpty) {
                                Text("Write email").foregroundColor(.init(red: 0.72, green: 0.75, blue: 0.79, opacity: 1.00))
                            }
                            .padding(10)
                            .padding(.horizontal, 25)
                            .foregroundColor(.black)
                            .background(Color(.white))
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.init(red: 0.72, green: 0.75, blue: 0.79, opacity: 4.00))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 10)
                                })
                    }
                    
                    Button {
                        
                        Task {
                            try await userViewModel.retrieveAllEmail(email: userSeacrh)
                            if (!userViewModel.user.isEmpty) {
                                
                                activatePicker.toggle()
                                
                            } else {
                                showingAlertRole.toggle()
                            }
                            
                        }
                        
                    } label: {
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.orange)
                                .overlay(
                                    Text("Search")
                                    .bold()
                                    .foregroundColor(.white))
                                .frame(width: 150, height: 50)
                            Spacer()
                        }
                    }
                    
                    if (activatePicker) {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("\(userViewModel.user.first?.username ?? "")")
                            
                            Text("E-mail: \(userViewModel.email)")
                                .font(.callout)
                                .bold()
                            
                            HStack {
                                Text("Roles")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .bold()
                                    .padding(5)
                                Button(action: {
                                    self.showPopUp = true
                                }, label: {
                                    Image(systemName: "info.circle")
                                })
                                
                            }
                            
                        }
                        
                        if (showPopUp) {
                            ZStack {
                                Color.white
                                VStack (alignment: .center, spacing: 10) {
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        
                                        Text("What can Roles do?")
                                            .font(.system(size: 16))
                                            .bold()
                                            .foregroundColor(.black)
                                            .padding(.bottom)
                                        
                                        Text("Collaborator")
                                            .font(.system(size: 13))
                                            .bold()
                                        
                                        Text("They have access to the same functions as you.")
                                            .font(.system(size: 10))
                                        
                                        Text("Promoter")
                                            .font(.system(size: 13))
                                            .bold()
                                        
                                        Text("They can only manage their lists.")
                                            .font(.system(size: 10))
                                        
                                        Text("Box-Office")
                                            .font(.system(size: 13))
                                            .bold()
                                        
                                        Text("They can access to the lists and scan QR Codes.")
                                            .font(.system(size: 10))
                                        
                                    }.multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                    
                                    Button(action: {
                                        self.showPopUp = false
                                    }, label: {
                                        Text("Close")
                                            .bold()
                                            .padding(.top)
                                    })
                                    
                                    
                                }.padding()
                                
                                
                            }.cornerRadius(10).shadow(radius: 10)
                                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.4)
                                .padding(.leading, 80)
                        }
                        
                        Picker("", selection: $selectedRole) {
                            Text("Collaborator").tag(0)
                            Text("Promoter").tag(1)
                            Text("Box-Office").tag(2)
                        }.pickerStyle(.inline)
                            .padding(.horizontal, 30)
                        
                    }
                    
                    Spacer()
                }.padding(.horizontal)
                
                    .onAppear() {
                        Task {
                            try await userViewModel.retrieveAll()
                            print("Event id: \(updateEventViewModel.eventID)")
                        }
                    }
                
                    .navigationTitle("Assign a Role")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel").fontWeight(.bold)
                    } ,trailing: Button(action: {
                        Task {
                            pushNotification.subscribe(textType: "Role", userName: userViewModel.user.first!.username)
                            if selectedRole == 0 {
                                permission = 0
                            }
                            else if selectedRole == 1 {
                                permission = 1
                            } else if selectedRole == 2 {
                                permission = 2
                            }
                            
                            try await roleViewModel.update(usename: userViewModel.user.first!.username, idEvent: updateEventViewModel.eventID, permission: permission)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add").fontWeight(.bold)
                        
                    } )
                
                if (showingAlertRole == true) {
                    AlertRole(show: $showingAlertRole)
                }
                
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

