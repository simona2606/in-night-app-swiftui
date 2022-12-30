//
//  AlertLogin.swift
//  N'Apples
//
//  Created by Simona Ettari on 14/12/22.
//

import SwiftUI

struct AlertLogin: View {
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Incorrect credentials!", comment: ""), isPresented: $showAlert, actions: {
            Button("Ok", action: {})
        }, message: {
            Text("Pleas try again.")
        })
    }
}
