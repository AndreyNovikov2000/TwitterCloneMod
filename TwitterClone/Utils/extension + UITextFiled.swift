//
//  extension + UITextFiled.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


extension UITextField {
    class func textField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.font = .systemFont(ofSize: 16)
        textField.textAlignment = .left
        textField.textColor = .white
        textField.tintColor = .white
        
        return textField
    }
}
