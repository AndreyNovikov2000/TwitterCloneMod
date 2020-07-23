//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/23/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    private let user: User
    var options: [ActionSheetOption] = []
    
    mutating private func addOptions() {
        if user.isCurrentUser {
            options.append(.delete)
        } else {
            let action: ActionSheetOption = user.isFollowed ? .unfollow(user) : .follow(user)
            options.append(action)
        }
        
        options.append(.report(user))
    }
    
    init(user: User) {
        self.user = user
        addOptions()
    }
}

enum ActionSheetOption {
    case follow(User)
    case unfollow(User)
    case report(User)
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.userName)"
        case .unfollow(let user):
            return "Unfollow @\(user.userName)"
        case .report(_):
            return "Report tweet"
        case .delete:
            return "Delete tweet"
        }
    }
}
