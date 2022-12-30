//
//  ContentView.swift
//  Qr
//
//  Created by Francesco on 09/05/22.
//

import SwiftUI

import CoreImage.CIFilterBuiltins


let context = CIContext()
let filter = CIFilter.qrCodeGenerator()

var showSaved = false
var qrScanned = ""

struct QrCodeView: View {
    
    let scView = ScannerView()

    @State var showScanner = false
    @State private var name = ""
    @State private var emailAddress = ""
    @State var show = showSaved
    @State var qrNumber = Int.random(in: 1...1999)
    
    var body: some View {
        NavigationView {
            ZStack{
                Form {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .font(.title)
                    
                    let qrImage = generateQRCode(from: "\(qrNumber)")
                    let image = Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    
                    
                    
                    TextField("Email address", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .font(.title)
                    
                    
                    Text("\(qrNumber)")
                        
                    
                    
//                    scView.$viewModel.lastQrCode
                    Text("Last Scanned Code: " + qrScanned)
                        
                    
                    
                    image
                        .onLongPressGesture{
                            //                        let image = Image(uiImage: qrImage as! UIImage)
                            
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrImage)
                            show.toggle()
                            
                        }
                    
                    Button("Scanner"){
                        showScanner.toggle()
                    }
                }
                .navigationTitle("Your code")
                
                
                if(showScanner){
                   
                   scView
                }
                
                
                    
                
                if(show){
                    
                    Alert(show: $show)
                }
                
            }
                        
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


func generateQRCode(from string: String) -> UIImage {
    filter.message = Data(string.utf8)
    
    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }
    
    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
