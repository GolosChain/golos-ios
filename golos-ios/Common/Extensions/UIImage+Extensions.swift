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
}
