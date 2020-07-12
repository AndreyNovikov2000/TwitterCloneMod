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
    
    
    // MARK: - Live cycle
    
    init(user: User) {
        self.user = user
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
        TweetService.shared.uploadTweet(caption: captionTextView.text) { (error, reference) in
            if let error = error {
                print("DEBUG: Error - \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Private methods
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
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
