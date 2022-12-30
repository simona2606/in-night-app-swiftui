//
//  pricePicker.swift
//  napples
//
//  Created by Gabriele Iorio on 02/06/22.
//

import SwiftUI

struct PricePicker: View {
    @Binding  var priceStartTime: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 2)

                HStack {
                    Text("Start Time").foregroundColor(.white)
                    DatePicker("", selection: $priceStartTime, displayedComponents: .hourAndMinute)
                }.padding(.horizontal)
                
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.2 )
    }
}


