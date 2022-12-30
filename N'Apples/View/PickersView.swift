//
//  PickersView.swift
//  napples
//
//  Created by Gabriele Iorio on 31/05/22.
//

import SwiftUI

struct PickersView: View {
    @Binding var birthDate: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 3)
                
            VStack {
                HStack {
                    Text("Date").foregroundColor(.white)
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                }
                
                Divider().foregroundColor(.white)
                HStack {
                    Text("Time").foregroundColor(.white)
                    DatePicker("", selection: $birthDate, displayedComponents: .hourAndMinute)
                }
            }
            .padding()
        }
    }
}
