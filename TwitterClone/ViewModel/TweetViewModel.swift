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
    
    var caption: String {
        return tweet.caption
    }
    
    var fullName: String {
        return tweet.user.fullName
    }
    
    var userName: String {
        return "@\(tweet.user.userName)"
    }
    
    var headerTimesTamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm · MM/dd/YYYY"
        return formatter.string(from: tweet.date)
    }
    
    var retweetsAttributeString: NSAttributedString? {
        return getAttributedText(withValue: tweet.retweetCount, text: "retweets")
    }
    
    var likesAttributedString: NSAttributedString {
        return getAttributedText(withValue: tweet.likes, text: "likes")
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .black : .lightGray
    }
    
    var likeButtonImage: UIImage? {
        return tweet.didLike ? UIImage(named: "like_filled") : UIImage(named: "like")
    }
    
    // MARK: - Private properties
    
    private let tweet: Tweet
    
    private var timetamp: String {
        let formatter = DateComponentsFormatter()
        let now = Date()
        
        formatter.allowedUnits = [.second, .minute, .hour, .weekday, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(tweet.timetamp)), to: now) ?? "0s"
    }
    
    // MARK: - Init
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    // MARK: - Public methods
    
    func getSize(width: CGFloat) -> CGSize {
        let mesurmentLabel = UILabel()
        mesurmentLabel.numberOfLines = 0
        mesurmentLabel.lineBreakMode = .byWordWrapping
        mesurmentLabel.text = tweet.caption
        mesurmentLabel.translatesAutoresizingMaskIntoConstraints = false
        mesurmentLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return mesurmentLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    // MARK: - Private methods
    
    private func getAttributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSMutableAttributedString(string: "\(text) ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                                          NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
