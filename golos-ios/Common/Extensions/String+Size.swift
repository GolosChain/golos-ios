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
}

extension String {
    func height(with font: UIFont, width: CGFloat) -> CGFloat {
        return (self as NSString).height(with: font, width: width)
    }
}
