//
//  AuthService.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


struct AuthCredentials {
    let emal: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    
    func registerUser(credentionals: AuthCredentials, complition:@escaping (Error?, DatabaseReference) -> Void) {
        guard let imageData = credentionals.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = UUID().uuidString
        let storageRef = K.Firebase.storageProfileImage.child(fileName)
        
        // STORAGE
        storageRef.putData(imageData, metadata: nil) { (storageData, error) in
            if let error = error {
                print("DEBUG: Error - \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("DEBUG: Error - \(error.localizedDescription)")
                    return
                }
                
                guard let imageUrlString = url?.absoluteString else { return }
                
                // AUTH
                self.auth.createUser(withEmail: credentionals.emal, password: credentionals.password) { (authResult, error) in
                    if let error = error {
                        print("DEBUG: Error - \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = authResult?.user.uid else { return }
                   
                    
                    let values = [K.UserRefence.email: credentionals.emal,
                                 K.UserRefence.userName: credentionals.userName,
                                 K.UserRefence.fullName: K.UserRefence.fullName,
                                 K.UserRefence.profileImageUrl: imageUrlString]
                    // DATABASE
                    K.Firebase.userRefernce.child(uid).updateChildValues(values, withCompletionBlock: complition)
                }
            }
        }
    }
    
    
    func signIn(withEmail email: String, password: String, complition: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error - \(error.localizedDescription)")
                complition(nil, error)
                return
            }
            
            complition(authResult, nil)
        }
    }
}

