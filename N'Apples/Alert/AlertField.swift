//
//  AlertField.swift
//  N'Apples
//
//  Created by Simona Ettari on 02/01/23.
//

import SwiftUI

import SwiftUI

struct AlertField: View {
    @Binding var showAlertField: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Error!", comment: ""), isPresented: $showAlertField, actions: {
            Button("Ok", action: {})
        }, message: {
            Text("Pleas complete all fields.")
        })
    }
}
