//
//  LoginView.swift
//  N'Apples
//
//  Created by Simona Ettari on 20/05/22.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct RegistrationView: View {
    
    //To change color of button in the dark mode
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var userSettings = UserSettings()
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var roleModel: RoleModel
    @EnvironmentObject var eventModel: EventModel
    
    @State private var eye = false
    
    @State var presentAlert: Bool = false
    @State var showAlert: Bool = false
    @State var showAlertField: Bool = false
    @State var showAlertRegister: Bool = false
    @State var showAlertEmail: Bool = false
    @State var showAlertPw: Bool = false
    
    private var isSignedIn: Bool {
        !userModel.userID.isEmpty
    }
    
    @State var flag = false
    @State var login = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                GeometryReader {
                    geometry in
                
                    Image(uiImage: UIImage(named: "doodle")!)
                        .position(x: geometry.size.width * 0.83, y: geometry.size.height * 0.0)

                    VStack {
                        Text("Welcome to\n").font(.system(size: 35).weight(.semibold))
                            .foregroundColor(.white) + Text("InNight").font(.system(size: 45).weight(.bold))
                            .foregroundColor(.orange)
                    }.frame(width: geometry.size.width * 1, height: geometry.size.width * 0.56, alignment: .center).padding(.top, 35).multilineTextAlignment(.center)
                    
                    VStack {
                        
                        Image(uiImage: UIImage(named: "party")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.72, height: geometry.size.width * 0.62)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.41)
                        
                        TextField("Username", text: $userModel.username)
                            .font(.system(size: 18))
                            .padding(.horizontal, 40)
                        Divider()
                            .padding(.horizontal, 40)
                            .padding(.bottom, 18)
                        TextField("Email", text: $userModel.email)
                            .font(.system(size: 18))
                            .padding(.horizontal, 40)
                        Divider()
                            .padding(.horizontal, 40)
                            .padding(.bottom, 18)
                        

                        HStack(spacing: 15) {
                            
                            if eye {
                                TextField("Password", text: $userModel.password)
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 40)
                                
                            }
                            else {
                                SecureField("Password", text: $userModel.password)
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 40)
                                
                            }
                            
                            Button(action: {
                                self.eye.toggle()
                            })
                            {
                                if eye {
                                    Image(systemName: "eye")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)
                                        .padding(.horizontal, 40)
                                        .foregroundColor(.gray)
                                } else {
                                    Image(systemName: "eye.slash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)
                                        .padding(.horizontal, 40)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            
                        }
                        
                        Divider()
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                        
                        HStack {
                            NavigationLink(destination: EventsView(), isActive: $login) {
                                Button(action: {
                                    Task {
                                        if(userModel.password.isEmpty || userModel.email.isEmpty || userModel.username.isEmpty) {
                                            showAlertField = true
                                        } else {
                                            try await userModel.retrieveAllEmail(email: userModel.email)
                                            if !userModel.user.isEmpty {
                                                let usrDef = UserDefaults.standard
                                                usrDef.set(userModel.username, forKey: "username")
                                                
                                                userSettings.id = userModel.username
                                                
                                                login = true
                                            } else {
                                                showAlert = true
                                            }
                                        }
                                    }
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.accentColor)
                                            .frame(width: geometry.size.width * 0.40, height: geometry.size.width * 0.11, alignment: .center)
                                        Text("Login")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                })
                                
                            }
                            
                            
                            Button(action: {
                                let check = isValidEmailAddress(emailAddressString: userModel.email)
                                Task {
                                    if(userModel.password.isEmpty || userModel.email.isEmpty || userModel.username.isEmpty) {
                                        showAlertField = true
                                    } else if (!check) {
                                        showAlertEmail = true
                                    } else if (userModel.password.count < 8) {
                                        showAlertPw = true
                                    } else {
                                        try await userModel.insert(username: userModel.username, password: userModel.password, email: userModel.email)
                                        let usrDef = UserDefaults.standard
                                        usrDef.set(userModel.username, forKey: "username")
                                        userSettings.id = userModel.username
                                        showAlertRegister = true
                                    }
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.accentColor)
                                        .frame(width: geometry.size.width * 0.40, height: geometry.size.width * 0.11, alignment: .center)
                                    Text("Register")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            })
                        }.padding()
                        
                        
                        if !isSignedIn {
                            
                            SignInButtonView(flag: $flag)
                                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                                .frame(width: geometry.size.width * 0.60, height: geometry.size.width * 0.17, alignment: .center)
                                .padding(.bottom)
                        } else {
                            NavigationLink(destination: EventsView(), isActive: $flag) {
                                Button(action: {
                                    
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.accentColor)
                                            .frame(width: geometry.size.width * 0.60, height: geometry.size.width * 0.10, alignment: .center)
                                        Text("Login")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                    }
                                })
                                
                            }
                        }
                        
                    }
                    if (showAlert) {
                        AlertLogin(showAlert: $showAlert)
                    }
                    if (showAlertEmail) {
                        AlertEmail(showAlertEmail: $showAlertEmail)
                    }
                    if (showAlertPw) {
                        AlertPw(showAlertPw: $showAlertPw)
                    }
                    if (showAlertRegister) {
                        AlertReg(showAlertRegister: $showAlertRegister)
                    }
                    if (showAlertField) {
                        AlertField(showAlertField: $showAlertField)
                    }
                    
                }
                
                .onAppear() {
                    userSettings.id = ""
                    userModel.email = ""
                    userModel.username = ""
                    userModel.password = ""
                    
                    userModel.reset()
                    roleModel.reset()
                    eventModel.reset()
                   
                    Task {
                        try await userModel.retrieveAllId(id: userSettings.id)
                    }
                }
       
            }.background(Image(uiImage: UIImage(named: "sfondo")!).resizable())
                .ignoresSafeArea()

        }
        .navigationBarHidden(true)
        
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
            
            var returnValue = true
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            
            do {
                let regex = try NSRegularExpression(pattern: emailRegEx)
                let nsString = emailAddressString as NSString
                let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
                
                if results.count == 0
                {
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            
            return  returnValue
        }
    
}
