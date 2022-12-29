//
//  ViewController.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit

class SignUpVC: UIViewController {

    // MARK: - UI Elements
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height) {
        didSet {
            scrollView.contentSize = contentViewSize
            containerView.frame.size = contentViewSize
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentViewSize
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        
        configureNotifications()
        layout()
    }
    
    // MARK: - Methods
    
    fileprivate func layout() {
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

