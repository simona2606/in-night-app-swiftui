//
//  RecapView.swift
//  Qr
//
//  Created by Francesco on 11/05/22.
//

import Foundation
import SwiftUI



struct RecapView: View {
    
    @State var name = "Francesco"
    @State var surname = "De Marco"
    @State var email = "prova@gmail.com"
    @State var list = "PerCoca"
    @State var nFriends = 6
    @State var timeScan:Date = Date()
    @State var numScan = 1
    
    var body: some View{
        ZStack {
            VStack{
                Text("Name: " + name)
                Text("Surname: " + surname)
                Text("Email: " + email)
                Text("List: " + list)
                Text("Entrance: \(numScan)/\(nFriends)")
                    
            }
            

        }
    }

}
