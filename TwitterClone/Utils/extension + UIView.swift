//
//  extension + UIView.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


extension UIView {
    static func inputContainerView(withImage image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        let dividerView = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.image = image
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .white
        
        // image view
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // text field
        view.addSubview(textField)
        
        textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive = true
        
        // divider view
        view.addSubview(dividerView)
        
        dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }
}
