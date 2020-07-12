//
//  Constants.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/11/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Firebase


struct K {
    struct Firebase {
        static let reference = Database.database().reference()
        static let userRefernce = Database.database().reference().child("users")
        
        static let storage = Storage.storage().reference()
        static let storageProfileImage = Storage.storage().reference().child("profile_image")
    }
    
    struct UserRefence {
        static let email = "email"
        static let userName = "userName"
        static let fullName = "fullName"
        static let profileImageUrl = "profileImageUrl"
    }
    
    
}


