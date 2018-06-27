//
//  PostCreateView.swift
//  Golos
//
//  Created by msm72 on 14.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import IQKeyboardManagerSwift

class PostCreateView: UIView {
    // MARK: - IBOutlets
    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = UIColor.clear
        }
    }

    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.tune()
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.tune(withPlaceholder:        "Enter Post Title Placeholder",
                                textColors:             blackWhiteColorPickers,
                                font:                   UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio),
                                alignment:              .left)
            
            titleTextField.inputAccessoryView    =   UIView()
            titleTextField.delegate              =   self
        }
    }
    
    
    // MARK: - Class Initialization
    init(withThemeName name: String?) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 375.0 * widthRatio, height: 70.0 * heightRatio)))
        
        createFromXIB()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    func createFromXIB() {
        UINib(nibName: String(describing: PostCreateView.self), bundle: Bundle(for: PostCreateView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
}


// MARK: - UITextFieldDelegate
extension PostCreateView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
