//
//  UIColor+extensions.swift
//  Remind me
//
//  Created by Andrey Versta on 24.06.2022.
//

import UIKit

extension UIColor {
    convenience init(
        hexRed: Int,
        hexGreen: Int,
        hexBlue: Int,
        alpha: CGFloat = 1
    ) {
        assert(0 <= hexRed && hexRed <= 255, "Invalid red component")
        assert(0 <= hexGreen && hexGreen <= 255, "Invalid green component")
        assert(0 <= hexBlue && hexBlue <= 255, "Invalid blue component")
        
        self.init(
            red: CGFloat(hexRed) / 255.0,
            green: CGFloat(hexGreen) / 255.0,
            blue: CGFloat(hexBlue) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(
            hexRed: (hex >> 16) & 0xff,
            hexGreen: (hex >> 8) & 0xff,
            hexBlue: hex & 0xff,
            alpha: alpha
        )
    }
}
