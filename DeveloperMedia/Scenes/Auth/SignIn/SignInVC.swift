//
//  SignInVC.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit

final class SignInVC: BaseAuthVC {

    fileprivate let signInButton: DMButton = {
        let button = DMButton(title: "Sign In", cornerRadius: 4)
        button.addTarget(nil, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTextFields()
        configureStackView()
        stackView.addArrangedSubview(signInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.applyGradient()
    }
    
    fileprivate func setTextFields() {
        textFields = [
            DMTextField(placeHolder: "Your Email", leftImage: UIImage(named: "mail")),
            DMTextField(placeHolder: "Your Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true),
        ]
    }
    
    fileprivate func configureStackView() {
        textFields.forEach { textField in
            stackView.addArrangedSubview(textField)
        }
    }
    
    @objc func handleSignIn() {
        print("Test")
    }
}
