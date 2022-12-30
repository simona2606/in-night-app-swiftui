//
//  AlertReg.swift
//  N'Apples
//
//  Created by Simona Ettari on 14/12/22.
//

import SwiftUI

import Foundation
import SwiftUI

struct AlertReg: View {
    
    @Binding var showAlertRegister: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Great!", comment: ""), isPresented: $showAlertRegister, actions: {
            Button("Ok", action: {})
            }, message: {
              Text("Correctly Registered!")
            })
    }
}

