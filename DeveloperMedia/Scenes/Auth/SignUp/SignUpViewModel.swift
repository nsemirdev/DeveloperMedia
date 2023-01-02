//
//  SignUpViewModel.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Toast

fileprivate enum SignUpErrors: String, Error {
    case passwordsAreNotSame    = "Passwords are not same,\nplease retype."
    case emptyFieldError        = "Some fields are empty,\nplease fill."
}

protocol SignUpViewModelInterface {
    var delegate: SignUpInterface? { get set }
    func registerRequest(with info: [DMTextField])
    func error(on textField: DMTextField)
}

final class SignUpViewModel {
    let db = Firestore.firestore()
    weak var delegate: SignUpInterface?
    var errorState = false
    
    fileprivate func signUpUser(_ userInfo: User) {
        Auth.auth().createUser(withEmail: userInfo.email, password: userInfo.password) { [weak self] _, error in
            guard let self else { return }
            guard error == nil else {
                self.delegate?.registrationDidFinishWithError(description: error!.localizedDescription, style: .make())
                return
            }
            
            self.delegate?.registrationDidFinishWithSuccess()
            self.db.collection("users").addDocument(data: [
                "username": userInfo.username,
                "mail": userInfo.email
            ]) { error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                let mainTabBar = MainTabBarController()
                mainTabBar.currentUser = userInfo
                mainTabBar.modalPresentationStyle = .fullScreen
                self.delegate?.present(mainTabBar, animated: true)
                self.delegate?.hideToastActivity()
            }
        }
    }
}

extension SignUpViewModel: SignUpViewModelInterface {
    func error(on textField: DMTextField) {
        errorState = true
        delegate?.animateTextField(on: textField)
    }
    
    func registerRequest(with info: [DMTextField]) {
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
            
            signUpUser(user)
        }
    }
}
