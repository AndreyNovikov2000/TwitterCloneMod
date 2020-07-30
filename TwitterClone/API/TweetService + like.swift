//
//  TweetService + like.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/30/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

// MARK: - Tweet like

extension TweetService {
    func likeTweet(tweet: Tweet, response:@escaping ResponseComplition) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // set new likes
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        K.Firebase.tweetsRefence.child(tweet.tweetId).child(K.TweetRefence.likes).setValue(likes)
        
        if tweet.didLike {
            // remove like from database
            K.Firebase.userLikes.child(uid).child(tweet.tweetId).removeValue { (_, _) in
                K.Firebase.tweetLikes.child(tweet.tweetId).child(uid).removeValue(completionBlock: response)
            }
            
        } else {
            // add like to database
            K.Firebase.userLikes.child(uid).updateChildValues([tweet.tweetId:1]) { (_, _) in
                K.Firebase.tweetLikes.child(tweet.tweetId).updateChildValues([uid:1], withCompletionBlock: response)
            }
        }
    }
    
    
    func checkIfUserLikedTweet(_ tweet: Tweet, response:@escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        K.Firebase.userLikes.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { (snap) in
            response(snap.exists())
        }
    }
}
