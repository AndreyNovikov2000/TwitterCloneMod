//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/16/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol HeaderProfileViewDelegate: class {
    func profileHeader(_ profileHeader: ProfileHeader, didTappedBackButton backButton: UIButton)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - External properties
    weak var myDelegate: HeaderProfileViewDelegate?
    static let reuseId = "ProfileHeader"
    
    // MARK: - Public properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Private property
    
    // filter bar
    private lazy var filterBar: ProfileFilterView = {
        let view = ProfileFilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.myDelegate = self
        return view
    }()
    
    // first layer
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainBlue
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTappede), for: .touchUpInside)
        return button
    }()
    
    // second layer
    
    private let profileImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        
        return imageView
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.mainBlue, for: .normal)
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.addTarget(self, action: #selector(handleProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // labels layer
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nifoni Andrew"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@Nifon555"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "some available tex and captire remove this lines a code and rew to many strokes hwo does exist and notification labels how do you rprefer"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var userDetailsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel, bioLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    
    // bottom view
    private let underLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainBlue
        return view
    }()
    
    // folowing section
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFolowingLabeltapped)))
        label.text = "0 folowing"
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFolowsButtonTapped)))
        label.text = "12 followers"
        return label
    }()
    
    // MARK: - Live cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupConstraintsForFilterBar()
        setupConstraintsForFirsLayer()
        setupConstraintsForSecondLayer()
        setupConstraintsForLabelsLayer()
        setupConstraintsForFollowLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileButton.layer.cornerRadius = profileButton.frame.height / 2
    }
    
    // MARK: - Seelectors
    
    @objc private func handleBackButtonTappede(sender: UIButton) {
        myDelegate?.profileHeader(self, didTappedBackButton: sender)
    }
    
    @objc private func handleProfileButtonTapped() {
        print(#function)
    }
    
    @objc private func handleFolowingLabeltapped() {
        print(#function)
    }
    
    @objc private func handleFolowsButtonTapped() {
        print(#function)
    }
    
    // MARK: - Private methods
    
    private func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        profileButton.setTitle(viewModel.actionButtontitle, for: .normal)
        profileImageView.set(imageUrl: user.url)
        followersLabel.attributedText = viewModel.followsString
        followingLabel.attributedText = viewModel.followingString
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    // MARK: - Constraints
    
    private func setupConstraintsForFilterBar() {
        addSubview(filterBar)
        addSubview(underLineView)
        
        // filter view
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        filterBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        filterBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        filterBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        filterBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // under line view
        underLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: frame.width / 3).isActive = true
    }
    
    
    private func setupConstraintsForFirsLayer() {
        addSubview(containerView)
        containerView.addSubview(backButton)
        
        // container view
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // back button
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 42).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupConstraintsForSecondLayer() {
        addSubview(profileImageView)
        addSubview(profileButton)
        
        // profile image view
        profileImageView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // profile button
        profileButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        profileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setupConstraintsForLabelsLayer() {
        addSubview(userDetailsStack)
        
        userDetailsStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        userDetailsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        userDetailsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    private func setupConstraintsForFollowLabels() {
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.translatesAutoresizingMaskIntoConstraints = false
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        
        addSubview(followStack)
        followStack.topAnchor.constraint(equalTo: userDetailsStack.bottomAnchor, constant: 8).isActive = true
        followStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
    }
}


// MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func profileFilterView(_ profileFilterView: ProfileFilterView, didSelectedFilterItemAtIndexPath indexPath: IndexPath) {
        let width = UIScreen.main.bounds.width / 3
        UIView.animate(withDuration: 0.3) {
            self.underLineView.transform = CGAffineTransform(translationX: width * CGFloat(indexPath.row), y: 0)
        }
    }
}
