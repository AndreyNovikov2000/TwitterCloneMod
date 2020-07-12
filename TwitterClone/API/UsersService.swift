//
//  UsersService.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import Firebase

final class UserService {
    static let shared = UserService()
    
    private init() {
        
    }
    
    func fetchUser(response:@escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        K.Firebase.userRefernce.child(uid).observeSingleEvent(of: .value) { snapshot in
            let user = User(snapshoot: snapshot, uid: uid)
            response(user)
        }
    }
}
