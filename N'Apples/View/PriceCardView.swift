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
                .foregroundColor(.white)
            HStack {
                VStack(alignment:.leading) {
                    Text(tables)
                        .fontWeight(.bold)
                    Text("\(formattedDate(date: orariocard,format: "HH:mm"))")
                }
                
                Spacer()
                Text(prezzocard)
                    .fontWeight(.semibold)
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



