//
//  AppDelegate.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}

