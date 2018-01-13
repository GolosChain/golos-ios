//
//  Fonts.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class Fonts {
    static let shared = Fonts()
    private var cachedFonts = [String: UIFont]()
    
    func regular(with size: CGFloat) -> UIFont {
        let key = "system-regular - \(size)"
        
        if let cachedFont = cachedFonts[key] {
            return cachedFont
        }
        
        let font = UIFont.systemFont(ofSize: size, weight: .regular)
        cachedFonts[key] = font
        
        return font
    }
    
    func medium(with size: CGFloat) -> UIFont {
        let key = "system-medium - \(size)"
        
        if let cachedFont = cachedFonts[key] {
            return cachedFont
        }
        
        let font = UIFont.systemFont(ofSize: size, weight: .medium)
        cachedFonts[key] = font
        
        return font
    }
}
