//
//  ViewController.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit

final class SignUpVC: UIViewController {

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
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    fileprivate lazy var textFieldsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        textFields.forEach { txtField in
            stackView.addArrangedSubview(txtField)
        }
        return stackView
    }()
    
    fileprivate let textFields = [
        DMTextField(placeHolder: "Your Name", leftImage: UIImage(named: "person")),
        DMTextField(placeHolder: "Your Email", leftImage: UIImage(named: "mail")),
        DMTextField(placeHolder: "Your Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye")),
        DMTextField(placeHolder: "Confirm Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"))
    ]
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(textFieldsStack)
        
        configureNotifications()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFields.forEach { txtField in
            txtField.applyGradientBorder(colors: [UIColor(hex: "#A49BFEFF")!, UIColor(hex: "#5F61F0FF")!])
        }
    }
    
    // MARK: - Methods
    
    fileprivate func layout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(logoImageView.snp.width)
        }
        
        textFieldsStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
        }
    }
    
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
}

