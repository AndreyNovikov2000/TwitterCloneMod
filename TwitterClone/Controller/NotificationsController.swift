//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Nofications"
    }
}
