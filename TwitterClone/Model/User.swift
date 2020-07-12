//
//  User.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let fullName: String
    let email: String
    let userName: String
    let profileImageUrl: String
    let uid: String
    
    var url: URL? {
        return URL(string: profileImageUrl)
    }
    
    init(fullName: String, email: String, userName: String, profileImageUrl: String, uid: String) {
        self.fullName = fullName
        self.email = email
        self.userName = userName
        self.profileImageUrl = profileImageUrl
        self.uid = uid
    }
    
    init(snapshoot: DataSnapshot, uid: String) {
        let dictionaryValues = snapshoot.value as? [String: AnyObject]
        
        self.fullName = dictionaryValues?[K.UserRefence.fullName] as? String ?? ""
        self.email = dictionaryValues?[K.UserRefence.email] as? String ?? ""
        self.userName = dictionaryValues?[K.UserRefence.userName] as? String ?? ""
        self.profileImageUrl = dictionaryValues?[K.UserRefence.profileImageUrl] as? String ?? ""
        self.uid = uid
    }
}
