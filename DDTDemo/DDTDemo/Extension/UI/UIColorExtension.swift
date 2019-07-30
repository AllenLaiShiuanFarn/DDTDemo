//
//  UIColorExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/30.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        if hexString.count != 6 {
            fatalError("Hex code must 6 digit.")
        }
        
        var rgb: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        self.init(r: CGFloat((rgb & 0xFF0000) >> 16),
                  g: CGFloat((rgb & 0x00FF00) >> 8),
                  b: CGFloat((rgb & 0x0000FF)))
    }
    
    static var appleRed: UIColor {
        return UIColor(r: 255.0, g: 59.0, b: 48.0)
    }
    
    static var appleOrange: UIColor {
        return UIColor(r: 255.0, g: 149.0, b: 0.0)
    }
    
    static var appleYellow: UIColor {
        return UIColor(r: 255.0, g: 204.0, b: 0.0)
    }
    
    static var appleGreen: UIColor {
        return UIColor(r: 76.0, g: 217.0, b: 100.0)
    }
    
    static var appleTealBlue: UIColor {
        return UIColor(r: 90.0, g: 200.0, b: 250.0)
    }
    
    static var appleBlue: UIColor {
        return UIColor(r: 0.0, g: 122.0, b: 255.0)
    }
    
    static var applePurple: UIColor {
        return UIColor(r: 88.0, g: 86.0, b: 214.0)
    }
    
    static var applePink: UIColor {
        return UIColor(r: 255.0, g: 45.0, b: 85.0)
    }
}
