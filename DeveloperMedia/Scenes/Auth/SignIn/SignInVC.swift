//
//  SignInVC.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit
import Toast

protocol SignInInterface where Self: UIViewController {
    func animateTextField(on textField: DMTextField)
    func loginDidFinishWithError(description: String, style: ToastStyle)
    func loginDidFinishWithSuccess()
    func hideToastActivity()
}

final class SignInVC: BaseAuthVC {
    
    var viewModel: SignInViewModelInterface? {
        didSet {
            viewModel!.delegate = self
        }
    }
    
    fileprivate let signInButton: DMButton = {
        let button = DMButton(title: "Sign In", cornerRadius: 4)
        button.addTarget(nil, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel = SignInViewModel()
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
        view.hideAllToasts()
        viewModel?.loginRequest(with: textFields)
    }
}

extension SignInVC: SignInInterface {
    
    func animateTextField(on textField: DMTextField) {
        textField.animateError()
    }
    
    func loginDidFinishWithSuccess() {
        view.makeToastActivity(.center)
    }
    
    func loginDidFinishWithError(description: String, style: Toast.ToastStyle) {
        view.makeToast(description, position: .top, style: style)
    }
    
    func hideToastActivity() {
        view.hideToastActivity()
    }
}
