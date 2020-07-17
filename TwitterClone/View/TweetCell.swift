//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/13/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func tweetCell(_ tweetCell: TweetCell, handleProfileImageTapped: WebImageView)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - External properties
    
    weak var myDelegate: TweetCellDelegate?
    static let reuseId = "TweetCell"
    
    // MARK: - Public properties
    
    var tweet: Tweet? {
        didSet {
            set()
        }
    }
    
    // MARK: - Private properties
    
    private lazy var profileImageView: WebImageView = {
        let profileImageView = WebImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.backgroundColor = .mainBlue
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageViewTapped)))
        return profileImageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "caption"
        return label
    }()
    
    private let infoLabel = UILabel()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private let underLineView: UIView = {
        let underLineView = UIView()
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.backgroundColor = .systemGray
        return underLineView
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDomention(width: 20, height: 20)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDomention(width: 20, height: 20)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDomention(width: 20, height: 20)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDomention(width: 20, height: 20)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(handleSharedTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Live cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupConstraintsForFotterButtons()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    // MARK: - Selectors
    
    @objc private func handleCommentTapped() {
        print("DEBUG: \(#function)")
    }
    
    @objc private func handleRetweetTapped() {
        print("DEBUG: \(#function)")
    }
    
    @objc private func handleLikeTapped() {
        print("DEBUG: \(#function)")
    }
    
    @objc private func handleSharedTapped() {
        print("DEBUG: \(#function)")
    }
    
    @objc private func handleProfileImageViewTapped() {
        myDelegate?.tweetCell(self, handleProfileImageTapped: profileImageView)
    }
    
    // MARK: - Private methods
    
    private func set() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        infoLabel.attributedText = viewModel.userInfoText
        profileImageView.set(imageUrl: viewModel.imageUrl)

        captionLabel.text = tweet.caption
        
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        addSubview(profileImageView)
        addSubview(labelStack)
        addSubview(underLineView)
        
        
        // profile image view
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        // label stack
        labelStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12).isActive = true
        labelStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true
        labelStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
        infoLabel.text = "Eddie brock @venom"
        infoLabel.font = .systemFont(ofSize: 14)
        
        // underl line view
        underLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        underLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupConstraintsForFotterButtons() {
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, sharedButton])
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        addSubview(actionStack)
        
        actionStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        actionStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}



