//
//  NSAttributedString+Extensions.swift
//  Golos
//
//  Created by msm72 on 29.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func encodeHtml() -> String {
        let documentAttributes  =   [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        
        do {
            let htmlData        =   try self.data(from: NSRange(location: 0, length: self.length), documentAttributes: documentAttributes)
            
            if let htmlString = String(data: htmlData, encoding: String.Encoding.utf8) {
                return htmlString
            }
                
            else { return String() }
        }
            
        catch {
            return String()
        }
    }
}
