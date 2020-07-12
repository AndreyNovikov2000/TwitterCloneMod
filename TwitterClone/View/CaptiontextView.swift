//
//  CaptiontextView.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class CaptionTextView: UITextView {
    
    // MARK: - Private properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "Tweet me :D"
        return label
    }()
    
    // MARK: - Live cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configureTextView()
        setupConstraintsForPlaceHolderLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        backgroundColor = .white
        font = .systemFont(ofSize: 16)
        isScrollEnabled = false
    }
    
    // MARK: - Selector methods
    @objc private func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    // MARK: - Private methods
    
    private func setupConstraintsForPlaceHolderLabel() {
        addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
    }
    
    
}
