//
//  UIView.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit

enum DirectionType {
    case vertical
    case horizontal
}

extension UIView {

    func applyGradient(colors: [UIColor] = [UIColor(hex: "#A49BFEFF")!, UIColor(hex: "#7173EBFF")!]) {
        self.applyGradient(colors: colors, locations: nil)
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientBorder(colors: [UIColor], direction: DirectionType = .horizontal, cornerRadius: CGFloat = 0) {
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.cornerRadius = cornerRadius

        if direction == .horizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradient.locations = [0,1]
        }
        
        gradient.colors = colors.map { $0.cgColor }

        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.backgroundColor = UIColor.yellow.cgColor
        shape.cornerRadius = cornerRadius
        gradient.mask = shape
        
        layer.addSublayer(gradient)
    }
}
