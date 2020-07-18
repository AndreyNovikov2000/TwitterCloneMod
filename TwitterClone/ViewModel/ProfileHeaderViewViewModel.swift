//
//  ProfileHeaderViewViewModel.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/16/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


enum ProfileTweetOptions: Int, CaseIterable, CustomStringConvertible {
    case tweets
    case replikes
    case likees
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replikes:
            return "Tweets & Reposts"
        case .likees:
            return "Likes"
        }
    }
}


struct ProfileHeaderViewModel {
    private let user: User
    
    var followsString: NSAttributedString? {
        return getAttributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return getAttributedText(withValue: user.stats?.following ?? 0, text: "Following")
    }
    
    var actionButtontitle: String {
        if user.isCurrentUser {
            return "Edit profile"
        }
        
        if !user.isCurrentUser && user.isFollowed {
            return "Following"
        }
        
        if !user.isCurrentUser && !user.isFollowed {
            return "Follow"
        }
        
        return ""
    }
    
    var fullName: String {
        return user.fullName
    }
    
    var userName: String {
        return "@\(user.userName)"
    }
    
    init(user: User) {
        self.user = user
    }
    
    private func getAttributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSMutableAttributedString(string: "\(text) ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
