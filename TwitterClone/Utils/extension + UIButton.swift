//
//  extension + UIButton.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


extension UIButton {
    func makePretty() {
        setTitleColor(.mainBlue, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 21)
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
    }
}

extension UIButton {
    static func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }
}
