//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/13/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct TweetViewModel {
    
    // MARK: - Public properties
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: tweet.user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(tweet.user.userName)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " · \(timetamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }

    var imageUrl: URL? {
        return tweet.user.url
    }

    // MARK: - Private properties
    
    private let tweet: Tweet

    private var timetamp: String {
        let formatter = DateComponentsFormatter()
        let now = Date()
        
        formatter.allowedUnits = [.second, .minute, .hour, .weekday, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(tweet.timetamp)), to: now) ?? ""
    }
    
    // MARK: - Init
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
}
