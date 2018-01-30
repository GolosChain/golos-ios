//
//  String+Size.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 25/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension NSString {
    func height(with font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let height = self.boundingRect(with: size,
                                       options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                                       attributes: [NSAttributedStringKey.font: font],
                                       context: nil).size.height
        return height
    }
    
    func width(with font: UIFont, height: CGFloat) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let width = self.boundingRect(with: size,
                                       options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                                       attributes: [NSAttributedStringKey.font: font],
                                       context: nil).size.width
        return width
    }
}

extension String {
    func height(with font: UIFont, width: CGFloat) -> CGFloat {
        return (self as NSString).height(with: font, width: width)
    }
    
    func width(with font: UIFont, height: CGFloat) -> CGFloat {
        return (self as NSString).width(with: font, height: height)
    }
}
