//
//  ViewController.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit
import Toast

protocol SignUpVCInterface where Self: UIViewController {
    func animateTextField(on textField: DMTextField)
    func registrationDidFinishWithError(description: String, style: ToastStyle)
    func registrationDidFinishWithSuccess()
    func hideToastActivity()
}

final class SignUpVC: BaseAuthVC {

    var viewModel: SignUpViewModelInterface? {
        didSet {
            viewModel?.delegate = self
        }
    }
   
    fileprivate let signUpButton: DMButton = {
        let button = DMButton(title: "Sign Up", cornerRadius: 4)
        button.addTarget(nil, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel = SignUpViewModel()
        setTextFields()
        configureStackView()
        stackView.addArrangedSubview(signUpButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signUpButton.applyGradient()
    }
    
    fileprivate func setTextFields() {
        textFields = [
            DMTextField(placeHolder: "Your Name", leftImage: UIImage(named: "person")),
            DMTextField(placeHolder: "Your Email", leftImage: UIImage(named: "mail")),
            DMTextField(placeHolder: "Your Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true),
            DMTextField(placeHolder: "Confirm Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true)
        ]
    }
    
    fileprivate func configureStackView() {
        textFields.forEach { textField in
            stackView.addArrangedSubview(textField)
        }
    }

    // MARK: - Business Logic

    @objc func handleSignUp() {
        view.hideAllToasts()
        viewModel?.registerRequest(with: textFields)
    }
}

extension SignUpVC: SignUpVCInterface {
    func registrationDidFinishWithSuccess() {
        view.makeToastActivity(.center)
    }
    
    func hideToastActivity() {
        view.hideToastActivity()
    }
    
    func animateTextField(on textField: DMTextField) {
        textField.animateError()
    }
    
    func registrationDidFinishWithError(description: String, style: ToastStyle) {
        view.makeToast(description, position: .top, style: style)
    }
}
