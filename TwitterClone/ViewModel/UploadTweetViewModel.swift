//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/20/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration {
    case upload
    case replace(Tweet)
}

class UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    let shouldShowReplyLabel: Bool
    var userNameLabel: String?
    
    init(configuration: UploadTweetConfiguration) {
        switch configuration {
        case .upload:
            actionButtonTitle = "upload"
            placeholderText = "Tweet me :D"
            shouldShowReplyLabel = false
        case .replace(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            userNameLabel = "Replying to @\(tweet.user.userName)"
        }
    }
}
