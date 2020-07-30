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
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
    private func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
            self.checkUserIsLikedTheTweets()
        }
    }
    
    private func checkUserIsLikedTheTweets() {
        tweets.forEach { tweet in
            if let index = tweets.firstIndex(where: { $0.tweetId == tweet.tweetId }) {
                TweetService.shared.checkIfUserLikedTweet(tweet) { (didLike) in
                    guard didLike == true else { return }
                    self.tweets[index].didLike = true
                }
            }
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - TweetCellDelegate
extension FeedViewController: TweetCellDelegate {
    func tweetCell(_ tweetCell: TweetCell, handleProfileImageTapped: WebImageView) {
        guard let user = tweetCell.tweet?.user else { return }
        navigationController?.pushViewController(ProfileController(user: user), animated: true)
    }
    
    func tweetCell(_ tweetCell: TweetCell, handlereplyButtonTapped replyButton: UIButton) {
        guard let tweet = tweetCell.tweet else { return }
        let uploadVC = UploadTweetController(user: tweet.user, config: .replace(tweet))
        let navController = UINavigationController(rootViewController: uploadVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    func tweetCell(_ tweetCell: TweetCell, handleLikeButtonTapped likeButton: UIButton) {
        guard let tweet = tweetCell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { (_, _) in
            tweetCell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            tweetCell.tweet?.likes = likes
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweetViewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let textHeight = tweetViewModel.getSize(width: view.frame.width).height
    
        return CGSize(width: view.frame.width, height: textHeight + 72)
    }
}
