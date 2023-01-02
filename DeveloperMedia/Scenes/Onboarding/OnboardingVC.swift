//
//  OnboardingVC.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit
import Lottie
import SnapKit

final class OnboardingVC: UIViewController {
    
    // MARK: - UI Elements
    
    fileprivate var animationView: LottieAnimationView?
    
    fileprivate let signUpButton: DMButton = {
        let button = DMButton(title: "Sign Up", cornerRadius: 14)
        button.addTarget(nil, action: #selector(handleSignUpButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate let signInButton: DMButton = {
        let button = DMButton(title: "Sign In", cornerRadius: 14)
        button.addTarget(nil, action: #selector(handleSignInButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLottie()
        
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.applyGradient()
        signUpButton.applyGradient()
    }
    
    // MARK: - Methods
    
    fileprivate func layout() {
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.bottom.equalTo(signUpButton.snp.top).offset(-20)
        }
    }
    
    fileprivate func setupLottie() {
        animationView = .init(name: "lottie")
        view.addSubview(animationView!)
        animationView?.loopMode = .loop
        animationView?.play()
        animationView?.frame = view.bounds
    }
    
    fileprivate func presentViewController(to viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    // MARK: - OBJC Methods
    
    @objc fileprivate func handleSignUpButton() {
        presentViewController(to: SignUpVC())
    }
    
    @objc fileprivate func handleSignInButton() {
        presentViewController(to: SignInVC())
    }
}
