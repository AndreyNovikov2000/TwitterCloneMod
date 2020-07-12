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
}
