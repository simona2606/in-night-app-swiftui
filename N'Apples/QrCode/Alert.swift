//
//  Alert.swift
//  Qr
//
//  Created by Francesco on 09/05/22.
//

import Foundation
import SwiftUI

struct Alert: View{
    
    @Binding var show:Bool
    
    var body: some View{
        VStack{
            
        }.alert(NSLocalizedString("Fraaaatm!", comment: ""), isPresented: $show, actions: {
            Button("Ok", action: {showSaved = false })
            }, message: {
              Text("Saved in gallery!")
            })
    }
}

