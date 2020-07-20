//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UploadTweetController: UIViewController {
    
    // MARK: - Private properties
    
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var uploadViewModel = UploadTweetViewModel(configuration: config)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tweet", for: .normal)
        button.backgroundColor = .mainBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweetButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profileImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.layer.cornerRadius = 50 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .mainBlue
        imageView.set(imageUrl: user.url)
        
        return imageView
    }()
    
    private let captionTextView = CaptionTextView()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    
    // MARK: - Live cycle
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Selector methods
    
    @objc func handlecancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleUploadTweetButtonPressed() {
        TweetService.shared.uploadTweet(caption: captionTextView.text, type: config) { (error, reference) in
            if let error = error {
                print("DEBUG: Error - \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Private methods
    
    private func configureUI() {
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        
        view.backgroundColor = .white
        view.addSubview(stack)
        
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        actionButton.setTitle(uploadViewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = uploadViewModel.placeholderText
        replyLabel.text = uploadViewModel.userNameLabel
        replyLabel.isHidden = !uploadViewModel.shouldShowReplyLabel
        
        configureNavigationBar()
    }
    
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancelButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .mainBlue
    }
}
