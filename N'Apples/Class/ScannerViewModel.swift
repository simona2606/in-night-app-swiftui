//
//  ScannerViewModel.swift
//  Qr
//
//  Created by Nicola D'Abrosca on 10/05/22.
//

import Foundation

class ScannerViewModel: ObservableObject, Identifiable {
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "QR Value"
    @Published var backToContent: Bool = false
    @Published var checkValid: Bool = false
    
//    func onFoundQrCode(_ code: String) {
//        self.lastQrCode = code
//        backToContent.toggle()
//    }
}
