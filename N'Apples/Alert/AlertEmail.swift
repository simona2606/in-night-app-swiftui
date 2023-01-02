//
//  AlertEmail.swift
//  N'Apples
//
//  Created by Simona Ettari on 02/01/23.
//

import SwiftUI

struct AlertEmail: View {
    
    @Binding var showAlertEmail: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Invalid email format!", comment: ""), isPresented: $showAlertEmail, actions: {
            Button("Ok", action: {})
        }, message: {
            Text("Pleas try again.")
        })
    }
}
