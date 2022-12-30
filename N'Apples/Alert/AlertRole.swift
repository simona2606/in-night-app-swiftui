//
//  AlertRole.swift
//  N'Apples
//
//  Created by Simona Ettari on 08/06/22.
//

import Foundation
import SwiftUI

struct AlertRole: View {
    
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Ops..", comment: ""), isPresented: $show, actions: {
            Button("Ok", action: {})
            }, message: {
              Text("No user found. Try again.")
            })
    }
}
