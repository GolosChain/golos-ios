//
//  HandlersManager.swift
//  Golos
//
//  Created by msm72 on 10/25/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class HandlersManager: GSBaseViewController {
    // MARK: - Class Functions
    func handlerTapped(isLike: Bool, completion: @escaping (Bool?) -> Void) {
        // Check network connection
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            return
        }
        
        guard self.isCurrentOperationPossible() else { return }
        
        guard isLike else {
            self.showAlertView(withTitle: "Voting Verb", andMessage: "Cancel Vote Message", actionTitle: "ActionChange", needCancel: true, completion: { success in
                completion(success)
            })
            
            return
        }
        
        completion(nil)
    }
    
    func handlerTapped(isDislike: Bool, completion: @escaping (Bool) -> Void) {
        // Check network connection
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            return
        }
        
        guard self.isCurrentOperationPossible() else { return }
        
        // Dislike
        if isDislike {
            self.showAlertView(withTitle: "Voice Power Title", andMessage: "Voice Power Subtitle", attributedText: self.displayAlertView(byDislike: true), actionTitle: "Voice Power Title", needCancel: true, isCancelLeft: false, completion: { success in
                completion(success)
            })
        }
            
        // Undislike
        else {
            self.showAlertView(withTitle: "Voting Verb", andMessage: "Cancel Vote Message", attributedText: self.displayAlertView(byDislike: false), actionTitle: "ActionChange", needCancel: true, completion: { success in
                completion(success)
            })
        }
    }
    
    private func displayAlertView(byDislike isDislike: Bool) -> NSMutableAttributedString {
        let fullAttributedString = NSMutableAttributedString()
        
        if isDislike {
            let text1       =   "Voice Power Label 2".localized()
            let text2       =   "Voice Power Label 3".localized()
            let text3       =   "Voice Power Label 4".localized()
            let subtitle    =   "Voice Power Subtitle".localized()
            
            let strings     =   [subtitle, text1, text2, text3]
            
            // Set Subtitle
            for (index, string) in strings.enumerated() {
                let bulletPoint         =   "\u{2022}"
                let formattedString     =   index == 0 ? "\n\(string)\n" : "\(bulletPoint) \(string)\n"
                let attributedString    =   NSMutableAttributedString(string: formattedString)
                
                var paragraphStyle: NSMutableParagraphStyle
                
                paragraphStyle          =   NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                paragraphStyle.tabStops =   [NSTextTab(textAlignment: .left, location: 20, options: [NSTextTab.OptionKey: Any]())]
                
                paragraphStyle.headIndent           =   index == 0 ? 5 : 15
                paragraphStyle.lineSpacing          =   1.4
                paragraphStyle.defaultTabInterval   =   20
                paragraphStyle.firstLineHeadIndent  =   5
                
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(.font, value: UIFont(name: "SFProDisplay-Regular", size: 14.0)!, range: NSRange(location: 0, length: attributedString.length))
                
                fullAttributedString.append(attributedString)
            }
        }
            
        else {
            let subtitle    =   "Cancel Vote Message".localized()
            
            
            // Set Subtitle
            let formattedString     =   "\n\(subtitle)\n"
            let attributedString    =   NSMutableAttributedString(string: formattedString)
            
            var paragraphStyle: NSMutableParagraphStyle
            
            paragraphStyle          =   NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.tabStops =   [NSTextTab(textAlignment: .left, location: 20, options: [NSTextTab.OptionKey: Any]())]
            
            paragraphStyle.headIndent           =   5
            paragraphStyle.lineSpacing          =   1.4
            paragraphStyle.defaultTabInterval   =   20
            paragraphStyle.firstLineHeadIndent  =   5
            
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.font, value: UIFont(name: "SFProDisplay-Regular", size: 14.0)!, range: NSRange(location: 0, length: attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        
        return fullAttributedString
    }
}
