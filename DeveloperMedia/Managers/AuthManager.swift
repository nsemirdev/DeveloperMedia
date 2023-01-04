//
//  AuthManager.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 4.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class AuthManager {
    private init() {}
    static let shared = AuthManager()
    fileprivate let users = Firestore.firestore().collection("users")
    fileprivate let db = Firestore.firestore()
    fileprivate let storage = Storage.storage().reference()
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            guard let _ = result else { return }
            
            self.users.getDocuments { snapshot, error in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                
                for document in snapshot!.documents {
                    guard let userData = document.data()["mail"] else { return }
                    if userData as! String == email.lowercased() {
                        let user = User(email: email.lowercased(),
                                        password: password,
                                        username: document.data()["username"] as! String)
                        
                        completion(.success(user))
                    }
                    
                }
            }
            
        }
    }
    
    func signUp(with user: User, imageData: Data, delegate: SignUpInterface, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [weak self] _, error in
            guard let self else { return }
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            delegate.registrationDidFinishWithSuccess()
            
            self.db.collection("users").addDocument(data: [
                "username": user.username,
                "mail": user.email.lowercased()
            ]) { error in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                
                let ref = self.storage.child("profile_images/\(user.email.lowercased()).png")
                ref.putData(imageData) { _, error in
                    if error != nil {
                        completion(.failure(error!))
                        return
                    }
                    completion(.success(user))
                }
            }
        }
    }
}
