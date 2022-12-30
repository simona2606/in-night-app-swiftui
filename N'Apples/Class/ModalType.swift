//
//  ModalType.swift
//  N'Apples
//
//  Created by Simona Ettari on 14/12/22.
//

import Foundation

enum ModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    case add
    case update(Event)
}
