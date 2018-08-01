//
//  String+Dictionary.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

extension String {
    func height(with font: UIFont, width: CGFloat) -> CGFloat {
        let size    =   CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let height  =   self.boundingRect(with: size,
                                          options:      [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                                          attributes:   [NSAttributedStringKey.font: font],
                                          context:      nil).size.height
        return height
    }
    
    func width(with font: UIFont, height: CGFloat) -> CGFloat {
        let size    =   CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let width   =   self.boundingRect(with: size,
                                          options:      [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                                          attributes:   [NSAttributedStringKey.font: font],
                                          context:      nil).size.width
        return width
    }

    func toDictionary() -> [String: Any]? {
        Logger.log(message: "Success", event: .severe)

        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return json
        } catch {
            Logger.log(message: "\(error.localizedDescription)", event: .error)
        }
        
        return nil
    }
    
    mutating func localize() {
        self = self.localized()
    }
    
    
    /// Add proxy part to image URL
    func addImageProxy(withSize size: CGSize) -> String {
        return self.hasPrefix("https://images.golos.io") ?  self : "https://imgp.golos.io" + String(format: "/%dx%d/", size.width, size.height) + self
    }
    
    
    func encodeHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data:                 data,
                                          options:              [.documentType:         NSAttributedString.DocumentType.html,
                                                                 .characterEncoding:    String.Encoding.utf8.rawValue],
                                          documentAttributes:   nil)
        }
            
        catch {
            return NSAttributedString()
        }
    }
}
