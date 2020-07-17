//
//  TweetService.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import Firebase


final class TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String,  complition: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [String: Any] = [K.TweetRefence.uid: uid,
                                     K.TweetRefence.timetamp: Int(Date().timeIntervalSince1970),
                                     K.TweetRefence.likes : 0,
                                     K.TweetRefence.retweets: 0,
                                     K.TweetRefence.caption: caption]
        
        K.Firebase.tweetsRefence.childByAutoId().updateChildValues(values, withCompletionBlock: complition)
    }
    
    func fetchTweets(response:@escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        K.Firebase.tweetsRefence.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary[K.TweetRefence.uid] as? String else { return }
            let tweetId = snapshot.key
            
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(dictionary: dictionary, user: user, tweetId: tweetId)
                tweets.append(tweet)
                response(tweets)
            }
        }
    }
}
