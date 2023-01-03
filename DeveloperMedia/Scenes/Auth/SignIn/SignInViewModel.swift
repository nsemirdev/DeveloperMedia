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
        Auth.auth().signIn(withEmail: info[0].text, password: info[1].text) { [weak self] response, error in
            guard let self else { return }
            if error != nil {
                self.delegate?.loginDidFinishWithError(description: error!.localizedDescription, style: .make())
                return
            }
            guard let _ = response?.user else { return }
            let mail = info[0].text.lowercased()
            self.delegate?.loginDidFinishWithSuccess()
            var user: User?
            
            self.users.getDocuments { snapshot, error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                for document in snapshot!.documents {
                    guard let userData = document.data()["mail"] else { return }
                    if userData as! String == mail {
                        user = User(email: mail, password: info[1].text, username: document.data()["mail"] as! String)
                    }
                }
                self.loginUser(with: user!)
            }
        }
    }
    
    func loginUser(with user: User)   {
        let mainTabBar = MainTabBarController()
        mainTabBar.currentUser = user
        mainTabBar.modalPresentationStyle = .fullScreen
        mainTabBar.modalTransitionStyle = .flipHorizontal
        self.delegate?.present(mainTabBar, animated: true)
        self.delegate?.hideToastActivity()
    }

}
