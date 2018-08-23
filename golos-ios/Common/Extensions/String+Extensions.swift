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
    func addFirstZero() -> String {
        return self.count == 1 ? "0" + self : self
    }

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
    
    
    /// Check entered Tag title simbol
    func checkTagTitleRule() -> Bool {
        let pattern             =   "^[a-zа-яё0-9-ґєії]+$"
        let regex               =   try! NSRegularExpression(pattern: pattern)

        return regex.matches(in: self, range: NSRange.init(location: 0, length: self.count)).count != 0
    }
    
    
    /// Rule 1: convert image URL -> markdown format
    func convertUsersAccounts() -> String {
        var result              =   NSMutableString.init(string: self)
        
        let pattern             =   "[@]\\w+[-.]\\w+|@\\w+"
        let regex               =   try! NSRegularExpression(pattern: pattern)
        let matches             =   regex.matches(in: result as String, range: NSRange.init(location: 0, length: result.length))
        
        for match in matches.reversed() {
            let accountString   =   (result as NSString).substring(with: match.range)
            result              =   result.replacingCharacters(in: match.range, with: String(format: "[%@](%@)", accountString, accountString)) as! NSMutableString
        }
        
        return result as String
    }

    func convertImagePathToMarkdown() -> String {
        var result              =   self
        let pattern             =   "(http(s?):)([/|.|\\w|\\s|-])*\\.(?:jpg|gif|png)(!d)?"
        let regex               =   try! NSRegularExpression(pattern: pattern)
        let matches             =   regex.matches(in: result, range: NSRange.init(location: 0, length: result.count))
        
        for match in matches.reversed() {
            let imageURLString  =   (result as NSString).substring(with: match.range)
            
            // Check if image URL present in markdown format: ![]()
            guard (result as NSString).range(of: String(format: "![](%@)", imageURLString), options: NSString.CompareOptions.caseInsensitive).length == 0 else {
                return result
            }
            
            result              =   result.replacingOccurrences(of: imageURLString, with: String(format: "![](%@)", imageURLString))
        }
        
        return result
                .convertHtmlTagCenter()
                .convertHtmlTagStrong()
                .convertHtmlTagParagraph()
                .replacingOccurrences(of: "<img src=\"", with: "")
                .replacingOccurrences(of: "\" alt=\"\" ", with: "")
                .replacingOccurrences(of: "width=\"840\" ", with: "")
                .replacingOccurrences(of: "height=\"108\" ", with: "")
                .replacingOccurrences(of: "/>", with: "")
                .replacingOccurrences(of: "<img class=\"", with: "\n\n")
                .replacingOccurrences(of: "alignnone", with: "")
                .replacingOccurrences(of: "size-large", with: "")
                .replacingOccurrences(of: "wp-image-8538\"", with: "")
                .replacingOccurrences(of: "src=\"", with: "")
    }
    
    private func convertHtmlTagCenter() -> String {
        return self
                .replacingOccurrences(of: "<center>", with: "")
                .replacingOccurrences(of: ")</center>", with: "#center)")
    }
    
    private func convertHtmlTagParagraph() -> String {
        return self
                .replacingOccurrences(of: "<p>", with: "\n")
                .replacingOccurrences(of: "</p>", with: "")
    }

    private func convertHtmlTagStrong() -> String {
        return self
                .replacingOccurrences(of: "<strong>", with: "**")
                .replacingOccurrences(of: "</strong>", with: "**")
    }

}
