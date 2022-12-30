//
//  PriceCardView.swift
//  N'Apples
//
//  Created by Simona Ettari on 20/12/22.
//

import SwiftUI

struct PriceCardView: View {
    var orariocard : Date
    var prezzocard : String
    var tables: String
    
    var body : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            HStack {
                VStack(alignment:.leading, spacing: 2) {
                    Text(tables)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(formattedDate(date: orariocard,format: "HH:mm"))")
                        .foregroundColor(.white)
                }
                
                Spacer()
                Text(prezzocard)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .foregroundColor(.black)
            .padding(.horizontal)
        }
    }
    
    func formattedDate(date:Date,format:String)->String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.string(from: date)
    }
}



