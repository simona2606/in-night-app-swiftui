//
//  AlertPw.swift
//  N'Apples
//
//  Created by Simona Ettari on 02/01/23.
//

import SwiftUI

struct AlertPw: View {
    @Binding var showAlertPw: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Invalid password!", comment: ""), isPresented: $showAlertPw, actions: {
            Button("Ok", action: {})
        }, message: {
            Text("Password must have at least 8 characters.")
        })
    }
}
