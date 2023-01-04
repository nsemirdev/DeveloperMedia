//
//  SceneDelegate.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            let mail = UserDefaults.standard.string(forKey: "email")
            let password = UserDefaults.standard.string(forKey: "password")
            window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "launchScreen")
            
            AuthManager.shared.signIn(withEmail: mail!, password: password!) { [weak self] result in
                switch result {
                case .success(let user):
                    let vc = MainTabBarController()
                    vc.currentUser = user
                    DispatchQueue.main.async {
                        self?.window?.rootViewController = vc
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        } else {
            window?.rootViewController = OnboardingVC()
        }
    }
}

