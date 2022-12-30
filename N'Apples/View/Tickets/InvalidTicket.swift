//
//  InvalidTicket.swift
//  N'Apples
//
//  Created by Simona Ettari on 23/12/22.
//

import SwiftUI

struct InvalidTicket: View {
    
    var body: some View {
        ZStack {
            GeometryReader{ geometry in
                Image(uiImage: UIImage(named: "sfondo")!).resizable()
                    .ignoresSafeArea()
                VStack(spacing: 50) {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Text("Inalid Ticket")
                                .foregroundColor(.red)
                                .underline()
                                .bold()
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                            
                            Spacer()
                        }
                        
                        Image("notValid")
                            .frame(width: geometry.size.width*0.5)
                    }
                }
            }
        }
    }
}
