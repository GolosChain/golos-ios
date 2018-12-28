//
//  UITextView+Extensions.swift
//  Golos
//
//  Created by msm72 on 14.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//  https://archimboldi.me/posts/how-to-display-and-arrange-images-and-text-in-uitextview.html
//

import UIKit
import GoloSwift
import SwiftTheme
import SwiftGifOrigin

extension UITextView {
    func tune(textColors: ThemeColorPicker?, font: UIFont?, alignment: NSTextAlignment) {
        self.font                       =   font
        self.theme_textColor            =   textColors
        self.textAlignment              =   alignment
    }
    
    func centerVertically() {
        let fittingSize                 =   CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size                        =   sizeThatFits(fittingSize)
        let topOffset                   =   (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset           =   max(1, topOffset)
        
        contentOffset.y                 =   -positiveTopOffset
    }
    
    func showToolbar(handlerAction: ((Int) -> Void)?) {
        let toolbar: UIToolbar          =   UIToolbar(frame: CGRect.init(x: 0.0, y: 0.0,
                                                                         width: UIScreen.main.bounds.width * widthRatio, height: 56.0 * heightRatio))
        toolbar.barStyle                =   .default
        toolbar.theme_barTintColor      =   whiteBlackColorPickers
        toolbar.theme_tintColor         =   darkGrayWhiteColorPickers
        toolbar.isTranslucent           =   false
        
        toolbar.sizeToFit()
        toolbar.add(shadow: true, onside: .top)

        let flexSpace                   =   UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let boldButton                  =   BlockBarButtonItem(image:           UIImage(named: "icon-button-bold-normal"),
                                                               style:           .done,
                                                               tag:             0,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })

        boldButton.isEnabled            =   false
        
        let italicButton                =   BlockBarButtonItem(image:           UIImage(named: "icon-button-italic-normal"),
                                                               style:           .done,
                                                               tag:             1,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        italicButton.isEnabled          =   false
        
        let underlineButton             =   BlockBarButtonItem(image:           UIImage(named: "icon-button-underline-normal"),
                                                              style:           .done,
                                                              tag:             2,
                                                              actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        underlineButton.isEnabled       =   false
        
        let leftAlignmentButton         =   BlockBarButtonItem(image:           UIImage(named: "icon-button-left-alignment-normal"),
                                                               style:           .done,
                                                               tag:             3,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        leftAlignmentButton.isEnabled   =   false
        
        let centerAlignmentButton       =   BlockBarButtonItem(image:           UIImage(named: "icon-button-center-alignment-normal"),
                                                               style:           .done,
                                                               tag:             4,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        centerAlignmentButton.isEnabled =   false
        
        let rightAlignmentButton        =   BlockBarButtonItem(image:           UIImage(named: "icon-button-right-alignment-normal"),
                                                               style:           .done,
                                                               tag:             5,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })

        rightAlignmentButton.isEnabled  =   false
        
        let emailButton                 =   BlockBarButtonItem(image:           UIImage(named: "icon-button-email-normal"),
                                                               style:           .done,
                                                               tag:             6,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        emailButton.isEnabled           =   false
        
        let linkButton                  =   BlockBarButtonItem(image:           UIImage(named: "icon-button-link-normal"),
                                                               style:           .done,
                                                               tag:             7,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        linkButton.isEnabled            =   true

        let imageButton                 =   BlockBarButtonItem(image:           UIImage(named: "icon-button-picture-frame-normal"),
                                                               style:           .done,
                                                               tag:             8,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })

        imageButton.isEnabled           =   true
        
        let smileButton                 =   BlockBarButtonItem(image:           UIImage(named: "icon-button-happy-normal"),
                                                               style:           .done,
                                                               tag:             9,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                                })
        
        smileButton.isEnabled           =   false
        
        let closeButton                 =   BlockBarButtonItem(image:           UIImage(named: "icon-button-close-normal"),
                                                               style:           .done,
                                                               tag:             10,
                                                               actionHandler: { tag in
                                                                    handlerAction!(tag)
                                                               })
        
        closeButton.isEnabled           =   true
        
        let items = [ flexSpace, boldButton, flexSpace, italicButton, flexSpace, underlineButton, flexSpace, leftAlignmentButton, flexSpace, centerAlignmentButton, flexSpace, rightAlignmentButton, flexSpace, emailButton, flexSpace, linkButton, flexSpace, imageButton, flexSpace, smileButton, flexSpace, closeButton, flexSpace ]
        
        toolbar.items                   =   items
        self.inputAccessoryView         =   toolbar
    }
    
    func add(object: Any) {
        var attributedStringWithImage: NSAttributedString
        let attachment                  =   NSTextAttachment()
        var attributedString            =   NSMutableAttributedString(string: "\n")
        
        // Image
        if let image = object as? UIImage { //}, let imageGIF = UIImage.gif(data: image.pngData()!) {
            let attachedImage           =   image.resizeBy(width: self.frame.width * 3)!
//            attachment.image            =   imageGIF

            attachment.image            =   attachedImage
            attachment.bounds           =   CGRect.init(origin: .zero, size: CGSize(width: attachedImage.size.width / 3, height: attachedImage.size.height / 3))
            attributedStringWithImage   =   NSAttributedString(attachment: attachment)
 
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(attributedStringWithImage)
            attributedString.append(NSAttributedString(string: "\n"))
        }
        
        // Link
        if let link = object as? (String, String) {
            let linkAttributes: [NSAttributedString.Key: Any] =  [
                                                                    .link:              link.1,
                                                                    .foregroundColor:   UIColor.blue,
                                                                    .underlineStyle:    NSUnderlineStyle.single.rawValue
                                                                ]

            let linkAttributedString = NSMutableAttributedString(string: String(format: "%@", link.0))
            linkAttributedString.setAttributes(linkAttributes, range: NSRange.init(location: 0, length: link.0.count))
            linkAttributedString.append(NSAttributedString(string: " "))
            
            attributedString = linkAttributedString
        }
        
        // Add this attributed string to the current position
        self.textStorage.insert(attributedString, at: self.selectedRange.location)
    }
    
    
    /// Get content of UITextView as [Attachment]
    func getParts() -> [Attachment] {
        var parts   =   [Attachment]()
        
        let attributedString    =   self.attributedText!
        let range               =   NSRange.init(location: 0, length: attributedString.length)
       
        attributedString.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, _) in
            if object.keys.contains(NSAttributedString.Key.attachment) {
                if let attachment = object[NSAttributedString.Key.attachment] as? NSTextAttachment {
                    // Image
                    if let image = attachment.image {
                        parts.append(Attachment(origin: image))
                    }
                    
//                    // Image
//                    else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
//                        parts.append(Attachment(origin: image))
//                    }
                }
            }
            
            // Link
            else if object.keys.contains(NSAttributedString.Key.link) {
                let linkKey     =   attributedString.attributedSubstring(from: range).string
                let linkPath    =   attributedString.attributedSubstring(from: range).attribute(.link, at: 0, longestEffectiveRange: nil, in: range) as! String
                
                if !linkKey.trimmingCharacters(in: .whitespaces).isEmpty {
                    parts.append(Attachment(markdownValue: String(format: "[%@](%@)", linkKey, linkPath), origin: (linkKey, linkPath)))
                }
            }
                
            else {
                let stringValue =   attributedString.attributedSubstring(from: range).string
                
                if !stringValue.trimmingCharacters(in: .whitespaces).isEmpty {
                    parts.append(Attachment(markdownValue: stringValue, origin: stringValue))
                }
            }
        }
     
        return parts
    }
    
    
    // Placeholder
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        }
            
        else {
            let label                   =   PlaceholderLabel(frame: .zero)
            label.font                  =   UIFont(name: "SFProDisplay-Regular", size: 15.0)
            label.theme_textColor       =   darkGrayWhiteColorPickers
            
            addSubview(label)
           
            return label
        }
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        
        set {
            let placeholderLabel                =   self.placeholderLabel
            
            placeholderLabel.text               =   newValue
            placeholderLabel.numberOfLines      =   0
            
            let width                           =   frame.width - textContainer.lineFragmentPadding * 2
            let size                            =   placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            
            placeholderLabel.frame.size.height  =   size.height
            placeholderLabel.frame.size.width   =   width
            placeholderLabel.frame.origin       =   CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
            
            textStorage.delegate = self
        }
    }
}


extension UITextView: NSTextStorageDelegate {
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden   =   !text.isEmpty
        }
    }
}
