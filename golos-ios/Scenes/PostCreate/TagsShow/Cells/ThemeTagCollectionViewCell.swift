//
//  TagCollectionViewCell.swift
//  golos-ios
//
//  Created by msm72 on 18.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import SwiftTheme
import IQKeyboardManagerSwift

class ThemeTagCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var isClearButtonTaped: Bool = false
    var firstResponderWidth: CGFloat = 78.0 * widthRatio
    
    var completionEndEditing: (() -> Void)?
    var completionClearButton: ((Bool) -> Void)?    // Bool = keyboard show or hide
    var completionChangeTitle: ((CGFloat, String?, String) -> Void)?
    var completionStartEditing: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.alpha                 =   0
            textField.layer.borderWidth     =   1
            textField.layer.borderColor     =   UIColor(hexString: "#1298FF").cgColor
            textField.layer.cornerRadius    =   textField.frame.height / 2 * heightRatio
            textField.font                  =   UIFont(name: "SFProDisplay-Regular", size: 13.0)
            textField.textAlignment         =   .center
            
            textField.inputAccessoryView    =   UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0 * widthRatio, height: 30.0 * heightRatio)))
            
            let paddingView                 =   UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0 * widthRatio, height: 30.0 * heightRatio)))
            textField.leftView              =   paddingView
            textField.leftViewMode          =   .always
            
            textField.delegate              =   self

            UIView.animate(withDuration: 0.3) {
                self.textField.alpha        =   1
            }
        }
    }
    
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.frame.size          =   CGSize(width: 15.0 * widthRatio, height: 15.0 * widthRatio)
            clearButton.layer.cornerRadius  =   clearButton.frame.height / 2
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach( { $0.constant *= widthRatio })
        }
    }
        
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    
    // MARK: - Actions
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        self.isClearButtonTaped = true
        self.completionClearButton!(IQKeyboardManager.sharedManager().keyboardShowing)
    }
}


// MARK: - ConfigureCell
extension ThemeTagCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        if let tag = item as? Tag {
            self.textField.text         =   tag.title
            self.textField.placeholder  =   tag.placeholder
            self.clearButton.isEnabled  =   !tag.isFirst
            self.textField.tag          =   tag.id
        }
    }
}


// MARK: - UITextFieldDelegate
extension ThemeTagCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.firstResponderWidth        =   textField.frame.width
        self.isClearButtonTaped         =   false

        self.completionStartEditing!()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.isClearButtonTaped {
            self.completionEndEditing!()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.completionEndEditing!()

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var emojiCharacterSet = CharacterSet()
        emojiCharacterSet.insert(charactersIn: "\u{1F300}"..<"\u{1F700}")

        guard !emojiCharacterSet.contains(Unicode.Scalar.init(string) ?? .init(0)) else {
            return false
        }
        
        guard CharacterSet.alphanumerics.contains(Unicode.Scalar.init(string) ?? .init(0)) else {
            if string == " " && (textField.text?.count)! > 0 {
                self.completionChangeTitle!(self.firstResponderWidth, textField.text, string.lowercased())
                return false
            }
            
            else if string == "-" && !(textField.text?.contains("-"))! && (textField.text?.count)! > 0 || string.isEmpty  {
                return true
            }
            
            return false
        }
        
        let textLength = (textField.text?.count)! + string.count
        
        // Max Tag title length = 24
        guard textLength < 25 else {
            return false
        }
        
        guard string.checkTagTitleRule() || string.isEmpty || !string.isEmpty else {
            return false
        }
        
        var stringWidth: CGFloat = 0.0
        
        if string.isEmpty {
            // Delete character
            if range.length == 1 {
                stringWidth     =   ("\(textField.text!.last!)" as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 13.0)!]).width
            }
                
            // Delete text block
            else {
                let start       =   textField.text!.index(textField.text!.startIndex, offsetBy: range.location)
                let end         =   textField.text!.index(start, offsetBy: range.length)
                
                stringWidth     =   ("\(textField.text![start..<end])" as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 13.0)!]).width
            }
        }
            
        else {
            stringWidth         =   (string as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 13.0)!]).width
        }
        
        if textLength > 2 {
            self.firstResponderWidth += (string.isEmpty) ? -stringWidth : stringWidth
        }
        
        if textLength < 3 {
            self.firstResponderWidth = 78.0 * widthRatio
        }
        
        guard self.firstResponderWidth <= UIScreen.main.bounds.width - 16.0 * 2 * widthRatio else {
            return false
        }
        
        if self.firstResponderWidth < 78.0 * widthRatio {
            self.firstResponderWidth = 78.0 * widthRatio
        }
        
        if (textField.text?.isEmpty)! && string == " " {
            return false
        }
        
        self.completionChangeTitle!(self.firstResponderWidth, textField.text, string.lowercased())
        return string != " "
    }
}
