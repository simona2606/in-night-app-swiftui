//
//  AlertInsertPrice.swift
//  N'Apples
//
//  Created by Simona Ettari on 13/06/22.
//

import Foundation
import SwiftUI

struct AlertInsertPrice: View {
    
    @Binding var show: Bool
    @Binding var showInsertPrice: Bool
   
    
    var body: some View {
        VStack {
           
            
        }.alert(NSLocalizedString("Great!", comment: ""), isPresented: $showInsertPrice, actions: {
            Button("Ok", action: {
                show = true

            })
        }, message: {
            Text("Price added correctly.")
            
        })
        
    }
}
