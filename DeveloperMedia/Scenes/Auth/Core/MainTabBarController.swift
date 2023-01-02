//
//  MainTabBarController.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {

    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    fileprivate func setupViewControllers() {
        // TO DO
        let homeFeedVC = UIViewController()
        homeFeedVC.view.backgroundColor = .systemTeal
        homeFeedVC.tabBarItem.title = "Test"
        homeFeedVC.modalPresentationStyle = .fullScreen
        setViewControllers([homeFeedVC], animated: false)
    }
}
