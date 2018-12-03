//
//  UIImage+Extensions.swift
//  Golos
//
//  Created by msm72 on 11/28/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

extension UIImage {
    func merge(withOverlayImage overlayImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        let overlayHeight   =   self.size.height * 0.25
        let overlayWidth    =   overlayHeight * 1.44
        let overlayRect     =   CGRect(x: (self.size.width - overlayWidth) / 2, y: (self.size.height - overlayHeight) / 2, width: overlayWidth, height: overlayHeight)
        overlayImage.draw(in: overlayRect, blendMode: .normal, alpha: 0.6)
        let newImage        =   UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        // Or if you need a thinner border :
        // let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
