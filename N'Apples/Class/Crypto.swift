//
//  Crypto.swift
//  N'Apples
//
//  Created by Francesco on 18/05/22.
//

import Foundation
import CryptoKit
/// Create an ecnryption key from a given password
/// - Parameter password: The password that is used to generate the key
func keyFromPassword(_ password: String) -> SymmetricKey {
  // Create a SHA256 hash from the provided password
  let hash = SHA256.hash(data: password.data(using: .utf8)!)
  // Convert the SHA256 to a string. This will be a 64 byte string
  let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
  // Convert to 32 bytes
  let subString = String(hashString.prefix(32))
  // Convert the substring to data
  let keyData = subString.data(using: .utf8)!
 
  // Create the key use keyData as the seed
  return SymmetricKey(data: keyData)
}


func encryptParameter<T: Codable>(_ password: String, _ parameter: T) throws -> String  {
    let key = keyFromPassword(password)
        
    return try encryptCodableObject(parameter, usingKey: key)
    
}

/// Encrypt the given object that must be Codable and
/// return the encrypted object as a base64 string
/// - Parameters:
///   - object: The object to encrypt
///   - key: The key to use for the encryption
func encryptCodableObject<T: Codable>(_ object: T, usingKey key: SymmetricKey) throws -> String {
  // Convert to JSON in a Data record
  let encoder = JSONEncoder()
  let userData = try encoder.encode(object)
 
  // Encrypt the userData
  let encryptedData = try ChaChaPoly.seal(userData, using: key)
 
  // Convert the encryptedData to a base64 string which is the
  // format that it can be transported in
  return encryptedData.combined.base64EncodedString()
}

/// Decrypt a given string into a Codable object
/// - Parameters:
///   - type: The type of the resulting object
///   - string: The string to decrypt
///   - key: The key to use for the decryption
func decryptStringToCodableOject<T: Codable>(_ type: T.Type, from string: String,
                                             usingKey key: SymmetricKey) throws -> T {
  // Convert the base64 string into a Data object
    print("Stringa: \(string)")
  let data = Data(base64Encoded: string)!
  // Put the data in a sealed box
  let box = try ChaChaPoly.SealedBox(combined: data)
  // Extract the data from the sealedbox using the decryption key
  let decryptedData = try ChaChaPoly.open(box, using: key)
  // The decrypted block needed to be json decoded
  let decoder = JSONDecoder()
  let object = try decoder.decode(type, from: decryptedData)
  // Return the new object
  return object
}
