//
//  extension + UIColor.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    static let mainBlue = UIColor(r: 29, g: 161, b: 242)
    static let customRed = UIColor(r: 220, g: 78, b: 65)
    static let customPurple = UIColor(r: 128, g: 87, b: 194)
}

