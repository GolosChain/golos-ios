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
    var first: String {
        return String(prefix(1))
    }
    
    func lowercaseFirst() -> String {
        return first.lowercased() + String(dropFirst())
    }
    
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }

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
    
    /// Convert HTML -> String
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
    
    
    /// Rule 1: convert image URL -> markdown format
    func convertImagePathToMarkdown() -> String {
        var result              =   self
                                        .replacingOccurrences(of: "<center>", with: "")
                                        .replacingOccurrences(of: "</center>", with: "#center")
        
        let pattern             =   "(http(s?):)([/|.|\\w|\\s|-])*\\.(?:jpg|gif|png)(!d)?"
        let centerPattern       =   "#center"
        let regex               =   try! NSRegularExpression(pattern: pattern)
        
        let matches             =   regex.matches(in: result, range: NSRange.init(location: 0, length: result.count))
        let centerRanges        =   try! NSRegularExpression(pattern: centerPattern).matches(in: result, range: NSRange.init(location: 0, length: result.count)).compactMap({ $0.range })
        
        for match in matches {
            let imageURLString  =   (result as NSString).substring(with: match.range)
            let centerRange     =   NSRange.init(location: match.range.location + match.range.length, length: centerPattern.count)
            
            if centerRanges.contains(centerRange) {
                let otherRange  =   result.index(result.startIndex, offsetBy: centerRange.location)..<result.index(result.startIndex, offsetBy: centerRange.location + centerRange.length)
                result.removeSubrange(otherRange)

                result          =   result.replacingOccurrences(of: imageURLString, with: String(format: "![](%@%@)", imageURLString, centerPattern))
            }
            
            else {
                result          =   result.replacingOccurrences(of: imageURLString, with: String(format: "![](%@)", imageURLString))
            }
        }
        
        return result
    }
}
