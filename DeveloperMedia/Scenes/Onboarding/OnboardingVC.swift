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
    
    var animationView: LottieAnimationView?
    let signUpButton = DMButton(title: "Sign Up", cornerRadius: 14)
    let signInButton = DMButton(title: "Sign In", cornerRadius: 14)
    
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
            make.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.height.equalTo(50)
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
}
