//
//  UserSetting.swift
//  N'Apples
//
//  Created by Simona Ettari on 24/05/22.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var id: String {
        didSet {
            UserDefaults.standard.set(id, forKey: "id")
        }
    }
    
    init() {
        self.id = UserDefaults.standard.object(forKey: "id") as? String ?? ""
    }
}
