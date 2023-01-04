//
//  SignUpViewModel.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Toast
import UIKit

fileprivate enum SignUpErrors: String, Error {
    case passwordsAreNotSame    = "Passwords are not same,\nplease retype."
    case emptyFieldError        = "Some fields are empty,\nplease fill."
}

protocol SignUpViewModelInterface {
    var delegate: SignUpInterface? { get set }
    func registerRequest(with info: [DMTextField], profileImage: UIImage)
    func error(on textField: DMTextField)
}

final class SignUpViewModel {
    fileprivate let db = Firestore.firestore()
    fileprivate let storage = Storage.storage().reference()
    weak var delegate: SignUpInterface?
    var errorState = false
    
    fileprivate func signUpUser(_ userInfo: User, profileImage: UIImage) {
        AuthManager.shared.signUp(with: userInfo, imageData: profileImage.pngData()!, delegate: delegate!) { result in
            switch result {
            case .success(let user):
                let mainTabBar = MainTabBarController()
                mainTabBar.currentUser = user
                mainTabBar.modalPresentationStyle = .fullScreen
                mainTabBar.modalTransitionStyle = .flipHorizontal
                self.delegate?.present(mainTabBar, animated: true)
                self.delegate?.hideToastActivity()
            case .failure(let error):
                self.delegate?.registrationDidFinishWithError(description: error.localizedDescription, style: .make())
            }
        }
    }
}

extension SignUpViewModel: SignUpViewModelInterface {
    func error(on textField: DMTextField) {
        errorState = true
        delegate?.animateTextField(on: textField)
    }
    
    func registerRequest(with info: [DMTextField], profileImage: UIImage) {
        errorState = false
        info.forEach { txtField in
            if txtField.text.isEmpty {
                error(on: txtField)
            }
        }
        
        guard !errorState else {
            delegate?.registrationDidFinishWithError(description: SignUpErrors.emptyFieldError.rawValue, style: .make())
            return
        }

        if info[2].text != info[3].text {
            error(on: info[2])
            error(on: info[3])
            delegate?.registrationDidFinishWithError(description: SignUpErrors.passwordsAreNotSame.rawValue, style: .make())
        } else {
            let user = User(email: info[1].text,
                            password: info[2].text,
                            username: info[0].text)
            
            signUpUser(user, profileImage: profileImage)
        }
    }
}
