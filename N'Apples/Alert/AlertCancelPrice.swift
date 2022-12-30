//
//  AlertCancelPrice.swift
//  N'Apples
//
//  Created by Simona Ettari on 13/06/22.
//

import Foundation
import SwiftUI

struct AlertCancelPrice: View {
    
    @Binding var show: Bool
    @Binding var timePrices: [Date]
    @Binding var prices: [Int]
    @Binding var tables: [String]
    @Binding var ind: Int
    
    var body: some View {
        VStack {
            
        }.alert(NSLocalizedString("Delete", comment: ""), isPresented: $show, actions: {
            Button("Cancel", action: {})
            Button("Ok", action: {
                timePrices.remove(at: ind)
                tables.remove(at: ind)
                prices.remove(at: ind)

            })
            }, message: {
              Text("Are you sure you want to delete this price?")
            }
        )
    }
}
