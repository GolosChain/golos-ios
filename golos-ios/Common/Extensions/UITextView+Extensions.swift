//
//  UITextView+Extensions.swift
//  Golos
//
//  Created by msm72 on 14.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SwiftTheme

extension UITextView {
    func tune(withPlaceholder placeholder: String, textColors: ThemeColorPicker?, font: UIFont?, alignment: NSTextAlignment) {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        
        self.font                       =   font
        self.theme_textColor            =   textColors
        self.textAlignment              =   alignment
        
        self.attributedText             =   NSAttributedString(string:      placeholder.localized(),
                                                               attributes:  [ NSAttributedStringKey.foregroundColor: UIColor(hexString: "#828282") ])
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
        
        let leftAlignmentButton        =   BlockBarButtonItem(image:           UIImage(named: "icon-button-left-alignment-normal"),
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
        
        let items = [ flexSpace, boldButton, flexSpace, italicButton, flexSpace, underlineButton, flexSpace, leftAlignmentButton, flexSpace, centerAlignmentButton, flexSpace, rightAlignmentButton, flexSpace, emailButton, flexSpace, linkButton, flexSpace, imageButton, flexSpace, smileButton, flexSpace ]
        
        toolbar.items                   =   items
        self.inputAccessoryView         =   toolbar
    }
    
    func add(object: Any) {
        var attributedString    =   NSAttributedString()
        
        // Create and NSTextAttachment and add your image to it.
        let attachment          =   NSTextAttachment()
        
        if let image = object as? UIImage {
            attachment.image    =   image
            
            // Calculate new size
            let newImageWidth   =   self.bounds.size.width
            let scale           =   newImageWidth/image.size.width
            let newImageHeight  =   image.size.height * scale
            
            // Resize this
            attachment.bounds   =   CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHeight)
            
            // Put your NSTextAttachment into and attributedString
            attributedString    =   NSAttributedString(attachment: attachment)
        }
        
        if let link = object as? (String, String) {
            let linkAttributes: [NSAttributedStringKey: Any] =  [
                                                                    .link:              NSURL(string: link.1)!,
                                                                    .foregroundColor:   UIColor.blue
                                                                ]
            
            let linkAttributedString = NSMutableAttributedString(string: link.0)
            linkAttributedString.setAttributes(linkAttributes, range: NSRange(location: 0, length: link.0.count))
            
            attributedString    =   linkAttributedString
        }
        
        // Add this attributed string to the current position.
        self.textStorage.insert(attributedString, at: self.selectedRange.location)
    }
}
