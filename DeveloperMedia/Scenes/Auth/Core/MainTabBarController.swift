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
    
    let plusView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        configureTabBar()
    }

    override func viewDidLayoutSubviews() {
        plusView.applyGradient()
    }
    
    fileprivate func configureTabBar() {
        UITabBar.appearance().unselectedItemTintColor = .black
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.backgroundColor = .systemBackground
        plusView.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.6078431373, blue: 0.9960784314, alpha: 1)
        plusView.layer.cornerRadius = 80
        tabBar.addSubview(plusView)
        tabBar.clipsToBounds = true

        plusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tabBar.safeAreaLayoutGuide.snp.bottom)
            make.width.height.equalTo(160)
        }
        tabBar.sendSubviewToBack(plusView)
    }
    
    fileprivate func setupViewControllers() {
        // TO DO
        let homeFeedVC = UIViewController()
        homeFeedVC.view.backgroundColor = .systemBackground
        homeFeedVC.tabBarItem.title = "Home Feed"
        homeFeedVC.tabBarItem.image = .init(systemName: "house")
        homeFeedVC.modalPresentationStyle = .fullScreen
        
        let profileVC = ProfileVC()
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.image = .init(systemName: "person")
        
        let addPostVC = AddPostVC()
//        addPostVC.tabBarItem.image = UIImage(systemName: "plus")
        addPostVC.tabBarItem.image = UIImage(named: "plus")
        
        setViewControllers([homeFeedVC, addPostVC, profileVC], animated: false)

    }
}
