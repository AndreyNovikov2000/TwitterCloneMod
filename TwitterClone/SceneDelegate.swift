//
//  SceneDelegate.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        
        if Auth.auth().currentUser != nil {
            window?.rootViewController = MainTabController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        
        window?.makeKeyAndVisible()
    }
}

