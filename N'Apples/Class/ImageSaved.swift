//
//  ImageSaver.swift
//  Qr
//
//  Created by Francesco on 09/05/22.
//

import Foundation
import SwiftUI

class ImageSaved: NSObject {
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Saved in gallery")
    }
}
