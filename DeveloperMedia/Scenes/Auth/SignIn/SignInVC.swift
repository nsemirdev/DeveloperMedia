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
    
    // MARK: - UI Elements
    
    fileprivate let signInButton: DMButton = {
        let button = DMButton(title: "Sign In", cornerRadius: 4)
        button.addTarget(nil, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    fileprivate let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have any account?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#9999A7FF")
        return label
    }()
    
    fileprivate let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(nil, action: #selector(handleRightButton), for: .touchUpInside)
        return button
    }()
        
    fileprivate lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightButton)
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel = SignInViewModel()
        setTextFields()
        configureStackView()
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(labelStackView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.applyGradient()
    }
    
    // MARK: - Methods
    
    fileprivate func setTextFields() {
        textFields = [
            DMTextField(placeHolder: "Your Email", leftImage: UIImage(named: "mail")),
            DMTextField(placeHolder: "Your Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true),
        ]
    }
    
    fileprivate func presentViewController(to viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        present(viewController, animated: true)
    }
    
    fileprivate func configureStackView() {
        textFields.forEach { textField in
            stackView.addArrangedSubview(textField)
        }
    }
    
    // MARK: - Business Logic
    
    @objc fileprivate func handleSignIn() {
        view.hideAllToasts()
        viewModel?.loginRequest(with: textFields)
    }
    
    @objc fileprivate func handleRightButton() {
        presentViewController(to: SignUpVC())
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
