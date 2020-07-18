//
//  FeedController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class FeedViewController: UICollectionViewController {
    
    // MARK: - Public propertis
    
    var user: User? {
        didSet {
            configureProfileImage()
        }
    }
    
    // MARK: - Private properties
    
    private var tweets = [Tweet]()
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweets()
        configureUI()
        configureProfileImage()
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseId)
    }
    
    
    
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func configureProfileImage() {
        let profileImageView = WebImageView()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileImageView.set(imageUrl: user?.url)
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 36 / 2
        profileImageView.backgroundColor = .mainBlue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
}


// MARK: - UICollectionViewDataSource
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseId, for: indexPath) as! TweetCell
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.myDelegate = self
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension FeedViewController {
    
    
}


// MARK: - TweetCellDelegate
extension FeedViewController: TweetCellDelegate {
    func tweetCell(_ tweetCell: TweetCell, handleProfileImageTapped: WebImageView) {
        guard let user = tweetCell.tweet?.user else { return }
        navigationController?.pushViewController(ProfileController(user: user), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return K.Size.tweetCellSize
    }
}
