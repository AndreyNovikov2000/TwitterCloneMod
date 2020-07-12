//
//  RegistrationViewController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let imagePickerController = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddButtonPressed), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    
    private let showLoginButton: UIButton = {
        let button = UIButton().setAttributedButton("Already have an account?", " Log In")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShowLoginButtonButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(named: "mail")
        return .inputContainerView(withImage: image, textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")
        return .inputContainerView(withImage: image, textField: passwordTextField)
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        return .inputContainerView(withImage: image, textField: fullnameTextField)
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        return .inputContainerView(withImage: image, textField: usernameTextField)
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField: UITextField = .textField(with: "Email")
        //        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField: UITextField = .textField(with: "Password")
        //        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var fullnameTextField: UITextField = {
        let textField: UITextField = .textField(with: "Full name")
        //        textField.delegate = self
        return textField
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField: UITextField = .textField(with: "Username")
        //        textField.delegate = self
        return textField
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegistrationPressed), for: .touchUpInside)
        button.setTitle("Register", for: .normal)
        button.makePretty()
        return button
    }()
    
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupConstraintsForShowLoginButton()
        setupConstraintsForAddPhotoButton()
        setupConstraintsForStackView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKkeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKkeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Selector methods
    
    @objc private func handleShowLoginButtonButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleAddButtonPressed() {
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.sourceType = .photoLibrary
    }
    
    @objc private func handleRegistrationPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        guard let fullName = fullnameTextField.text, let userName = usernameTextField.text else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = AuthCredentials(emal: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        AuthService.shared.registerUser(credentionals: credentials) { error, reference in
         
            
        }
    }

    
    @objc private func handleKkeyboardNotification(notification: Notification) {
        guard let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
    }
    
    // MARK: - Private properties
    
    private func configureUI() {
        view.backgroundColor = .mainBlue
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    private func setupConstraintsForShowLoginButton() {
        view.addSubview(showLoginButton)
        
        showLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        showLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        showLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    private func setupConstraintsForAddPhotoButton() {
        view.addSubview(addPhotoButton)
        
        addPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    private func setupConstraintsForStackView() {
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, userNameContainerView, registrationButton])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
}


extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImage = image
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.height / 2
        addPhotoButton.layer.borderWidth = 3
        
        addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
