//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/21/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol TweetHeaderDelegate: class {
    func tweetHeader(_ tweetHeader: TweetHeader, optionButtonPressed optionButton: UIButton)
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - External properties
    
    weak var myDelegate: TweetHeaderDelegate?
    static let reuseId = "TweetHeader"
    
    // MARK: - Public properties
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Private properties
    
    // profile
    private lazy var profileImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageViewTapped)))
        imageView.backgroundColor = .mainBlue
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var profileStackView: UIStackView = {
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel, nameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let profileStackView = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.axis = .horizontal
        profileStackView.spacing = 12
        
        return profileStackView
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(handleOptionButtonTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return button
    }()
    
    // caption
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    // sstats view
    private lazy var statsView: UIView = {
        let statsView = UIView()
        statsView.translatesAutoresizingMaskIntoConstraints = false
        
        let topDeviderView = UIView()
        topDeviderView.translatesAutoresizingMaskIntoConstraints = false
        topDeviderView.backgroundColor = .lightGray
        
        let bottomDeviderView = UIView()
        bottomDeviderView.translatesAutoresizingMaskIntoConstraints = false
        bottomDeviderView.backgroundColor = .lightGray
        
        statsView.addSubview(topDeviderView)
        statsView.addSubview(bottomDeviderView)
        
        topDeviderView.topAnchor.constraint(equalTo: statsView.topAnchor).isActive = true
        topDeviderView.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 10).isActive = true
        topDeviderView.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -10).isActive = true
        topDeviderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        bottomDeviderView.bottomAnchor.constraint(equalTo: statsView.bottomAnchor).isActive = true
        bottomDeviderView.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 10).isActive = true
        bottomDeviderView.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -10).isActive = true
        bottomDeviderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let statsStack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsStack.axis = .horizontal
        statsStack.spacing = 12
        
        statsView.addSubview(statsStack)
        statsStack.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        statsStack.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 16).isActive = true
        
        return statsView
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "0 retweets"
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "0 likes"
        return label
    }()
    
    // action
    
    private lazy var commentButton: UIButton = {
        let button: UIButton = .createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button: UIButton = .createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button: UIButton = .createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button: UIButton = .createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 72
        return stackView
    }()
    
    
    
    
    // MARK: - Live cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForProfileStackView()
        setupConstraintsForCaptionLabelAndDateLabel()
        setupConstraintsForStatsView()
        setupConstraintsForActionStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    
    
    // MARK: - Selector methods
    
    @objc private func handleProfileImageViewTapped() {
          print(#function)
    }
    
    @objc private func handleOptionButtonTapped(sender: UIButton) {
        myDelegate?.tweetHeader(self, optionButtonPressed: sender)
    }
    
    @objc private func handleCommentButtonTapped() {
        print(#function)
    }
    
    @objc private func handleRetweetButtonTapped() {
        print(#function)
    }
    
    @objc private func handleLikeButtonTapped() {
        print(#function)
    }
    
    @objc private func handleShareButtonTapped() {
        print(#function)
    }
    
    
    
    // MARK: - Private methods
    
    private func configure() {
        guard let tweet = tweet else { return }
        let tweetViewModel = TweetViewModel(tweet: tweet)
        
        profileImageView.set(imageUrl: tweetViewModel.imageUrl)
        fullNameLabel.text = tweetViewModel.fullName
        captionLabel.text = tweetViewModel.caption
        nameLabel.text = tweetViewModel.userName
        dateLabel.text = tweetViewModel.headerTimesTamp
        retweetsLabel.attributedText = tweetViewModel.retweetsAttributeString
        likesLabel.attributedText = tweetViewModel.likesAttributedString
    }
    
    // MARK: - Constraints
    private func setupConstraintsForProfileStackView() {
        addSubview(profileStackView)
        addSubview(optionButton)
        
        profileStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        profileStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        optionButton.centerYAnchor.constraint(equalTo: profileStackView.centerYAnchor).isActive = true
        optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    private func setupConstraintsForCaptionLabelAndDateLabel() {
        addSubview(captionLabel)
        addSubview(dateLabel)
        
        // caption label
        captionLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 20).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        // date label
        dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 20).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
    
    private func setupConstraintsForStatsView() {
        addSubview(statsView)
        
        statsView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        statsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        statsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupConstraintsForActionStack() {
        addSubview(actionStack)
        
        actionStack.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 15).isActive = true
        actionStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
