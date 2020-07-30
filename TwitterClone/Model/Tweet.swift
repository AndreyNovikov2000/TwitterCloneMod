//
//  Tweet.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/13/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Tweet {
    let caption: String
    let uid: String
    var likes: Int
    let retweetCount: Int
    let timetamp: Int
    let tweetId: String
    var user: User
    var didLike = false
    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timetamp))
    }
    
    
    init(dictionary: [String: Any], user: User, tweetId: String) {
        self.caption = dictionary[K.TweetRefence.caption] as? String ?? ""
        self.uid = dictionary[K.TweetRefence.uid] as? String ?? ""
        self.likes = dictionary[K.TweetRefence.likes] as? Int ?? 0
        self.retweetCount = dictionary[K.TweetRefence.retweets] as? Int ?? 0
        self.timetamp = dictionary[K.TweetRefence.timetamp] as? Int ?? 0
        self.user = user
        self.tweetId = tweetId
    }
}

