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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, complition: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [String: Any] = [K.TweetRefence.uid: uid,
                                     K.TweetRefence.timetamp: Int(Date().timeIntervalSince1970),
                                     K.TweetRefence.likes : 0,
                                     K.TweetRefence.retweets: 0,
                                     K.TweetRefence.caption: caption]
        
        switch type {
        case .upload:
            let ref = K.Firebase.tweetsRefence.childByAutoId()
            ref.updateChildValues(values) { (error, refence) in
                guard let tweetId = ref.key else { return }
                
                // update user-tweet structer after uplode
                let value = [tweetId: 1]
                K.Firebase.userTweets.child(uid).updateChildValues(value)
                complition(error, refence)
            }
            
        case .replace(let tweet):
            K.Firebase.tweetReplies.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: complition)
        }
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
    
    func fetchTweets(forUser user: User,  complition: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        K.Firebase.userTweets.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            
            K.Firebase.tweetsRefence.child(tweetId).observeSingleEvent(of: .value) { tweetSnapshot in
                guard let tweetDictionary = tweetSnapshot.value as? [String: Any] else { return }
                guard let uid = tweetDictionary[K.TweetRefence.uid] as? String else { return }
                
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(dictionary: tweetDictionary, user: user, tweetId: tweetId)
                    tweets.append(tweet)
                    complition(tweets)
                    
                }
            }
        }
    }
    
    
    
    func fetchUser(fromTweet tweet: Tweet, response:@escaping (User) -> Void) {
        let ref = K.Firebase.tweetsRefence
        
        ref.child(tweet.tweetId).observeSingleEvent(of: .value) { snapshoot in
            let uid = snapshoot.key
            UserService.shared.fetchUser(uid: uid, response: response)
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, response:@escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        let tweetId = tweet.tweetId
        K.Firebase.tweetReplies.child(tweetId).observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict[K.TweetRefence.uid] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(dictionary: dict, user: user, tweetId: tweet.tweetId)
                tweets.append(tweet)
                response(tweets)
            }
        }
    }
    
    
}

