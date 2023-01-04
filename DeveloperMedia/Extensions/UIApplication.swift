//
//  UIApplication.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 4.01.2023.
//

import UIKit

extension UIApplication {
    static var safeAreaInsets: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}
