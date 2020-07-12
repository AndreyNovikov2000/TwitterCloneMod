//
//  FeedController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Public propertis
    
    var user: User? {
        didSet {
           configureProfileImage()
        }
    }
    
    // MARK: - Properties
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureProfileImage()
        
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
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
        profileImageView.backgroundColor = .red
        profileImageView.layer.cornerRadius = 36 / 2
        profileImageView.backgroundColor = .mainBlue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
