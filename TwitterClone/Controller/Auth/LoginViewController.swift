//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "TwitterLogo")
        return imageView
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(named: "mail")
        return .inputContainerView(withImage: image, textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")
        return .inputContainerView(withImage: image, textField: passwordTextField)
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField: UITextField = .textField(with: "Email")
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField: UITextField = .textField(with: "Password")
        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginButtonPressed), for: .touchUpInside)
        button.setTitle("Log in", for: .normal)
        button.makePretty()
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton().setAttributedButton("Don't have an account?", " Sigh up")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDontHaveAccountButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLogoImageView()
        setupConstraintsForStackView()
        setupConstraintsForDontHaveAccountButton()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Selector methods
    
    @objc private func handleLoginButtonPressed() {
        print("log in")
    }
    
    @objc private func handleDontHaveAccountButtonPressed() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .mainBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLogoImageView() {
        view.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    private func setupConstraintsForStackView() {
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setupConstraintsForDontHaveAccountButton() {
        view.addSubview(dontHaveAccountButton)
        
        dontHaveAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        dontHaveAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        dontHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return true
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
}



extension UIButton {
    func setAttributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                        NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }
}
