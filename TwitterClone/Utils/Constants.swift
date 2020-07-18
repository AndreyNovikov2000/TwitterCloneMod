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
        
        private let refence = Database.database().reference()
        
        // user
        static let reference = Database.database().reference()
        static let userRefernce = Database.database().reference().child("users")
        
        // tweets
        static let tweetsRefence = Database.database().reference().child("tweets")
        
        // storage image
        static let storage = Storage.storage().reference()
        static let storageProfileImage = Storage.storage().reference().child("profile_image")
        
        // user tweets
        static let userTweets = Database.database().reference().child("user-tweets")
        
        // user follows
        static let userFollowers = Database.database().reference().child("user-followers")
        
        // user following
        static let userFollowing = Database.database().reference().child("user-following")
    }
    
    struct UserRefence {
        static let email = "email"
        static let userName = "userName"
        static let fullName = "fullName"
        static let profileImageUrl = "profileImageUrl"
    }
    
    struct TweetRefence {
        static let uid = "uid"
        static let timetamp = "timetamp"
        static let likes = "likes"
        static let retweets = "retweet"
        static let caption = "caption"
    }
    
    struct Size {
        static let tweetCellSize = CGSize(width: UIScreen.main.bounds.width, height: 110)
    }
}


