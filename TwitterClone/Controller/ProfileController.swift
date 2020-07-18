//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/14/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    private var user: User?
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Live cycle
    
    init(user: User?) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout() )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchUser()
        checkUserIsFollowed()
        fetchStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.hidesBackButton = true
        
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let user = user else { return }
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkUserIsFollowed() {
        guard let user = user else { return }
        UserService.shared.checkUserIsFollowed(uid: user.uid) { isFollowed in
            self.user?.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchStats() {
        guard let user = user else { return }
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user?.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Public methods
    
    
    // MARK: - Private methods
    
    private func configureCollectionView() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseId)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.reuseId)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
    }
}


// MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseId, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.reuseId, for: indexPath) as? ProfileHeader else { return UICollectionReusableView() }
        header.user = user
        header.myDelegate = self
        return header
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return K.Size.tweetCellSize
    }
}


extension ProfileController: HeaderProfileViewDelegate {
    func profileHeader(_ profileHeader: ProfileHeader, backButtonTapped backButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func profileHeader(_ profileHeader: ProfileHeader, editButtonTapped backButton: UIButton) {
        guard let user = user else { return }
        
        if user.isCurrentUser {
            print("Show editing controller")
            return
        }
        
        
        if user.isFollowed {
         
            UserService.shared.unfollowUser(uid: user.uid) { (_, _) in
                self.user?.isFollowed = false
                self.fetchStats()
                self.collectionView.reloadData()
            }
            
        } else {
            UserService.shared.followUser(uid: user.uid) { (_, _) in
                self.user?.isFollowed = true
                self.fetchStats()
                self.collectionView.reloadData()
            }
        }
        
       
    }
}
