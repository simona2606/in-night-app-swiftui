//
//  AlertDelEvent.swift
//  N'Apples
//
//  Created by Simona Ettari on 30/12/22.
//

import SwiftUI

struct AlertDelEvent: View {
    @Binding var alertDelEvent: Bool
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Error!", comment: ""), isPresented: $alertDelEvent, actions: {
            Button("Ok", action: {})
            }, message: {
              Text("You can only delete an event if you are an administrator or collaborator.")
            })
    }
}

struct AlertDelEvent_Previews: PreviewProvider {
    static var previews: some View {
        AlertDelEvent(alertDelEvent: .constant(true))
    }
}
