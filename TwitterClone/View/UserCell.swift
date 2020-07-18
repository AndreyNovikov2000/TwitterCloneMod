//
//  UserCell.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/17/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol UserCellDelegate: class {
    
}

class UserCell: UITableViewCell {
    
    // MARK: - External properties
    
    weak var myDelegate: UserCellDelegate?
    static let reuseId = "UserCell"
    
    // MARK: - Public properties
    
    var user: User? {
        didSet {
            configureUser()
        }
    }

    // MARK: - Private properties
    
    private let profileImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .mainBlue
        return imageView
    }()
    
    // information labels
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "User name"
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "full name"
        return label
    }()
    
    // MARK: - Live cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        
        setupConstraintsForProfileImageView()
        setupImaformationLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius =  profileImageView.frame.height / 2
    }
    
    
    // MARK: - Private methods
    
    private func configureUser() {
        profileImageView.set(imageUrl: user?.url)
        userNameLabel.text = user?.userName
        fullNameLabel.text = user?.fullName
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    
    // MARK: - Constraimts
    
    private func setupConstraintsForProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    private func setupImaformationLabels() {
        let informationStackView = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        informationStackView.axis = .vertical
        informationStackView.spacing = 2
        
        addSubview(informationStackView)
        informationStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        informationStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12).isActive = true
    }
}
