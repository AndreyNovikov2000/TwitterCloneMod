//
//  UsersService.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import Firebase

typealias ResponseComplition = (Error?, DatabaseReference) -> Void

final class UserService {
    
    static let shared = UserService()
    private let currentUid = ""
    
    private init() {
        
    }
    
    func fetchUser(uid: String, response:@escaping (User) -> Void) {
        K.Firebase.userRefernce.child(uid).observeSingleEvent(of: .value) { snapshot in
            let user = User(snapshoot: snapshot, uid: uid)
            response(user)
        }
    }
    
    func fetchUsers(response:@escaping ([User]) -> Void) {
        var users = [User]()
        K.Firebase.userRefernce.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            let user = User(snapshoot: snapshot, uid: uid)
            users.append(user)
            response(users)
        }
    }
    
    func followUser(uid: String, complition: @escaping ResponseComplition) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // update currentUser following 
        K.Firebase.userFollowers.child(currentUid).updateChildValues([uid: 1]) { (_, _) in
            // update user followers
            K.Firebase.userFollowing.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: complition)
        }
    }
    
    func unfollowUser(uid: String, response: @escaping ResponseComplition) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Unfollow user, Following -user
        K.Firebase.userFollowers.child(currentUid).child(uid).removeValue { (_, _) in
            // // Unfollow user, Followers -user
            K.Firebase.userFollowing.child(uid).child(currentUid).removeValue(completionBlock: response)
        }
    }
    
    func checkUserIsFollowed(uid: String, complition: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        K.Firebase.userFollowers.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            complition(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, response:@escaping (UserRelationStats) -> Void) {
        
        K.Firebase.userFollowers.child(uid).observeSingleEvent(of: .value) { followersSnapshot in
            let followers = followersSnapshot.children.allObjects.count
           
            K.Firebase.userFollowing.child(uid).observeSingleEvent(of: .value) { followingSnapshot in
                let following = followingSnapshot.children.allObjects.count
                let stats = UserRelationStats(followers: followers, following: following)
                response(stats)
            }
        }
    }
}
