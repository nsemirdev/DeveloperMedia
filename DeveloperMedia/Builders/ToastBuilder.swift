//
//  ToastBuilder.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import UIKit
import Toast

extension ToastStyle {
    static func make() -> ToastStyle {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = UIColor(hex: "#A49BFEFF")!
        style.messageAlignment = .center
        style.messageFont = .systemFont(ofSize: 21)
        style.verticalPadding = 10
        style.horizontalPadding = 30
        style.displayShadow = true
        
        return style
    }
}
