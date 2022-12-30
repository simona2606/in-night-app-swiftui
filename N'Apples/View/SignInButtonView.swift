import SwiftUI
import AuthenticationServices

struct SignInButtonView: View {

    @ObservedObject var userSettings = UserSettings()
    @Binding var flag: Bool
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
             
            Task {
                switch result {
                case .success(let auth):
                    
                    switch auth.credential {
                        
                    case let credential as ASAuthorizationAppleIDCredential:
                        userModel.userID = credential.user
                        userModel.email = credential.email ?? ""
                        userModel.username = credential.fullName?.givenName ?? ""
                        
                        let usrDef = UserDefaults.standard
                        usrDef.set(userModel.username, forKey: "username")
                        
                        try await userModel.retrieveAllId(id: userModel.userID)
                        
                        if (userModel.user.isEmpty) {
                            try await userModel.insertApple(username: userModel.username, email: userModel.email, id: userModel.userID)
                            userSettings.id = userModel.userID
                            flag.toggle()
                        } else {
                            userSettings.id = userModel.userID
                            userModel.username = userModel.user.first!.username
                        }
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
        .cornerRadius(15)
        .padding(.bottom, 20)
    }
}
