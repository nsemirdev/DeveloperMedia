//
//  SignInViewModel.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol SignInViewModelInterface {
    var delegate: SignInInterface? { get set }
    func loginRequest(with info: [DMTextField])
    func error(on textField: DMTextField)
}

final class SignInViewModel {
    weak var delegate: SignInInterface?
    let users = Firestore.firestore().collection("users")
}

extension SignInViewModel: SignInViewModelInterface {
    func error(on textField: DMTextField) {
        delegate?.animateTextField(on: textField)
    }
    
    func loginRequest(with info: [DMTextField]) {
        AuthManager.shared.signIn(withEmail: info[0].text,
                                  password: info[1].text) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                self.delegate?.loginDidFinishWithSuccess()
                self.loginUser(with: user)
            case .failure(let error):
                self.delegate?.loginDidFinishWithError(description: error.localizedDescription, style: .make())
            }
        }
    }
  
    func loginUser(with user: User) {
        let mainTabBar = MainTabBarController()
        mainTabBar.currentUser = user
        mainTabBar.modalPresentationStyle = .fullScreen
        mainTabBar.modalTransitionStyle = .flipHorizontal
        self.delegate?.present(mainTabBar, animated: true)
        self.delegate?.hideToastActivity()
    }

}
