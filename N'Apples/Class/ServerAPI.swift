//
//  ServerAPI.swift
//  N'Apples
//
//  Created by Francesco on 15/06/22.
//

import Foundation

struct Entry: Decodable {
    var error: Bool
    var message: String
}

struct ResponseRes: Decodable {
    var error: Bool
    var message: String
    var reservation: ReservationStruct
}

struct ReservationStruct: Decodable {
    var id: String
    var name: String
    var surname: String
    var email: String
    var idEvent: String
    var nameList: String
    var numFriends: Int
}

func insertEventOnServer(idEvent: String, nameList: String) {
    
    let request = NSMutableURLRequest(url: NSURL(string:
                                                    "https://quizcode.altervista.org/API/discorganizer/insertLists.php")! as URL)
    request.httpMethod = "POST"
    let postIdEvent = "idEvent=" + idEvent
    let postNameList = "nameList=" + nameList
    let postString = postIdEvent + "&" + postNameList
    request.httpBody = postString.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        if error != nil {
            print("error=\(String(describing: error))")
            return
        }
        
        if let data = data {
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode(Entry.self, from: data)
                print(parsedJSON)
            } catch {
                print(error)
            }
        }
    }
    task.resume()
}

func getSingleReservation(id: String) {
    
    let reservationModel = ReservationModel()
    
    
    let request = NSMutableURLRequest(url: NSURL(string:
                                                    "https://quizcode.altervista.org/API/discorganizer/getSingleReservation.php")! as URL)
    request.httpMethod = "POST"
    let postId = "id=" + id
    
    
    request.httpBody = postId.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        if error != nil {
            
            print("error=\(String(describing: error))")
            
            return
        } else {
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let res = try jsonDecoder.decode(ResponseRes.self, from: data)
                    print("Reserve: \(res)")
                    Task {
                        try await reservationModel.retrieveAllEmail(email: res.reservation.email)
                        if reservationModel.reservation.isEmpty {
                            
                            try await reservationModel.insert(event: res.reservation.idEvent, id: res.reservation.id, name: res.reservation.name, surname: res.reservation.surname, email: res.reservation.email, nameList: res.reservation.nameList, numFriends: res.reservation.numFriends)
                            
                            try await reservationModel.updateNumScan(id: res.reservation.idEvent, numscan: 0)
                            
                            
                            
                        } else {
                            try await reservationModel.updateNumScan(id: res.reservation.idEvent, numscan: 0)
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }
        
    }
    task.resume()
}
