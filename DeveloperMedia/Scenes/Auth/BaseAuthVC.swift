//
//  BaseAuthVC.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import UIKit

class BaseAuthVC: UIViewController {

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
    
    open var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    open lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        textFields.forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    open var textFields = [DMTextField]()
    
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
}
