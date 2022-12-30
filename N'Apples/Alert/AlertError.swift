//
//  AlertError.swift
//  N'Apples
//
//  Created by Simona Ettari on 19/05/22.
//

import Foundation
import SwiftUI

struct AlertError: View {
    
    @Binding var show: Bool
    
    var body: some View{
        VStack{
            
        }.alert(NSLocalizedString("Ops..", comment: ""), isPresented: $show, actions: {
            Button("Ok", action: {})
            }, message: {
              Text("There is no event with this name, try again!")
            })
    }
}
