//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/23/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    static let reuseId = "ActionSheetCell"
   
    // MARK: - Public properties
    
    var option: ActionSheetOption? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Private properties
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "twitter_logo_blue")
        return imageView
    }()
    
    private let titleLabele: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.text = "Test"
        return label
    }()
    
    
    // MARK: - Live cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraintsForActionSheetCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupCell() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func configure() {
        titleLabele.text = option?.description
    }
    
    private func setupConstraintsForActionSheetCell() {
        addSubview(optionImageView)
        addSubview(titleLabele)
        
        optionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        optionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        optionImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        titleLabele.leadingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 12).isActive = true
        titleLabele.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        titleLabele.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
