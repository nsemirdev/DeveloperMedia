//
//  SignUpViewModel.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import Foundation

fileprivate enum SignUpErrors: String, Error {
    case passwordsAreNotSame    = "Passwords are not same,\nplease retype."
    case emptyFieldError        = "Some fields are empty,\nplease fill."
}

protocol SignUpViewModelInterface {
    var delegate: SignUpVCInterface? { get set }
    func registerRequest(with info: [DMTextField])
    func error(on textField: DMTextField)
}

final class SignUpViewModel {
    weak var delegate: SignUpVCInterface?
    var errorState = false
    
    fileprivate func signUpUser() {
        print("successfully signed up user")
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
            delegate?.registrationDidFinishWithError(description: SignUpErrors.emptyFieldError.rawValue)
            return
        }

        if info[2].text != info[3].text {
            error(on: info[2])
            error(on: info[3])
            delegate?.registrationDidFinishWithError(description: SignUpErrors.passwordsAreNotSame.rawValue)
        } else {
            delegate?.registrationDidFinishWithSuccess()
            signUpUser()
        }
    }
}
