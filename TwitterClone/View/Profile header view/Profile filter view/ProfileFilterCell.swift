//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/16/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    static let reuseId = "ProfileFilterCell"
    
    // MARK: - Public properties
    
    var option: ProfileTweetOptions? {
        didSet {
            titleLabel.text = option?.description
        }
    }
    
    // MARK: - Private properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = isSelected ? UIColor.mainBlue : UIColor.lightGray
        }
    }
    
    // MARK: - Live cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupConstraintsForTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupConstraintsForTitleLabel() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
