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
    func registrationDidFinishWithError(description: String)
    func registrationDidFinishWithSuccess()
    func hideToastActivity()
}

final class SignUpVC: UIViewController {

    var viewModel: SignUpViewModelInterface? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height) {
        didSet {
            scrollView.contentSize = contentViewSize
            containerView.frame.size = contentViewSize
        }
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentViewSize
        return scrollView
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        return view
    }()
    
    fileprivate let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        textFields.forEach { stackView.addArrangedSubview($0) }
        stackView.addArrangedSubview(signUpButton)
        return stackView
    }()
    
    fileprivate let textFields = [
        DMTextField(placeHolder: "Your Name", leftImage: UIImage(named: "person")),
        DMTextField(placeHolder: "Your Email", leftImage: UIImage(named: "mail")),
        DMTextField(placeHolder: "Your Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true),
        DMTextField(placeHolder: "Confirm Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true)
    ]
    
    fileprivate let signUpButton: DMButton = {
        let button = DMButton(title: "Sign Up", cornerRadius: 4)
        button.addTarget(nil, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(stackView)
        
        configureNotifications()
        layout()
        
        // Business Logic
        viewModel = SignUpViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signUpButton.applyGradient()
        textFields.forEach { txtField in
            txtField.applyGradientBorder(colors: [UIColor(hex: "#A49BFEFF")!, UIColor(hex: "#5F61F0FF")!])
        }
    }
    
    // MARK: - Methods
    
    fileprivate func layout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(logoImageView.snp.width)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
        }
    }
    
    // MARK: - Keyboard stuffs
    
    fileprivate func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + keyboardHeight)
        }
    }
    
    @objc func keyboardWillDisappear() {
        contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
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
    
    func registrationDidFinishWithError(description: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = UIColor(hex: "#A49BFEFF")!
        style.messageAlignment = .center
        style.messageFont = .systemFont(ofSize: 21)
        style.verticalPadding = 10
        style.horizontalPadding = 30
        style.displayShadow = true
        view.makeToast(description, position: .top, style: style)
    }
}
