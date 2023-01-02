//
//  DMButton.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit

final class DMButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        .init(width: 0, height: 50)
    }
    
    convenience init(title: String,
                     cornerRadius: CGFloat = 20,
                     gradientColors: [UIColor] = [UIColor(hex: "#A49BFEFF")!, UIColor(hex: "#7173EBFF")!],
                     titleColor: UIColor = .white,
                     titleFont: UIFont = .systemFont(ofSize: 18, weight: .regular),
                     type: UIButton.ButtonType = .system) {
        
        self.init(type: type)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = titleFont
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
