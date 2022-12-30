//
//  AlertDelete.swift
//  N'Apples
//
//  Created by Simona Ettari on 12/06/22.
//

import Foundation
import SwiftUI

struct AlertDelete: View {
    @Binding var show: Bool
   
    var body: some View {
        VStack {
           
        }.alert(NSLocalizedString("Great!", comment: ""), isPresented: $show, actions: {
            Button("Ok", action: { })
        }, message: {
            Text("Event successfully deleted.")
            
        })
        
    }
}
