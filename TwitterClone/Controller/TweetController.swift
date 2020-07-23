//
//  TweetController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class TweetController: UICollectionViewController {

    // MARK: - Private properties
    
    private let userService = UserService.shared
    private let tweet: Tweet
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var actionSheetLauncher: ActionSheetLauncher! {
        didSet {
            actionSheetLauncher.myDelagte = self
        }
    }
    
    // MARK: - Live cycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchReplies()
    }
    
    // MARK: - API
    
    private func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    
    // MARK: - Private properties
    
    private func configureCollectionView() {
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseId)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.reuseId)
        collectionView.backgroundColor = .white
    }
}


// MARK: - UICollectionViewDataSource
extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseId, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        cell.tweet = replies[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.reuseId, for: indexPath) as? TweetHeader else { return UICollectionReusableView() }
        
        headerView.tweet = tweet
        headerView.myDelegate = self
        
        return headerView
    }
}


// MARK: - UICollectionViewDelegate
extension TweetController {
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.getSize(width: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 260)
    }
}


// MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    func tweetHeader(_ tweetHeader: TweetHeader, optionButtonPressed optionButton: UIButton) {
        
        if tweet.user.isCurrentUser {
            actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
            self.actionSheetLauncher.show()
        } else {
            UserService.shared.checkUserIsFollowed(uid: tweet.user.uid) { isFollowing in
                var user = self.tweet.user
                user.isFollowed = isFollowing
                self.actionSheetLauncher = ActionSheetLauncher(user: user)
                self.actionSheetLauncher.show()
            }
        }
    }
}


// MARK: - ActionSheetLauncherDelegate
extension TweetController: ActionSheetLauncherDelegate {
    func actionSheet(_ actionSheet: ActionSheetLauncher, didSelectOption option: ActionSheetOption) {
        switch option {
        case .follow(let user):
            
            userService.followUser(uid: user.uid) { (err, ref) in
                print("Did follow user - \(user) ")
            }
            
        case .unfollow(let user):
             
            userService.unfollowUser(uid: user.uid) { (err, ref) in
                print("Did unfollow user - \(user)")
            }
            
        case .report(_):
             print(option.description)
        case .delete:
             print(option.description)
        }
    }
}
