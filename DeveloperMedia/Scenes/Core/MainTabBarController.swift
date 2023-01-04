//
//  MainTabBarController.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import UIKit
import FirebaseAuth

final class MainTabBarController: UITabBarController {

    var currentUser: User! {
        didSet {
            print(currentUser!.username)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser)
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        let homeFeedVC = UIViewController()
        homeFeedVC.view.backgroundColor = .systemBackground
        homeFeedVC.tabBarItem.title = "Home Feed"
        homeFeedVC.tabBarItem.image = .init(systemName: "house")
        homeFeedVC.modalPresentationStyle = .fullScreen
        
        let profileVC = ProfileVC()
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.image = .init(systemName: "person")
        
        let addPostVC = AddPostVC()
        addPostVC.tabBarItem.image = UIImage(systemName: "plus")
        addPostVC.tabBarItem.title = "Add Post"
        
        setViewControllers([homeFeedVC, addPostVC, profileVC], animated: false)
    }
}
