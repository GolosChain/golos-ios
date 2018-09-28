//
//  PostingKeyShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 10.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift
import IQKeyboardManagerSwift

class PostingKeyShowViewController: GSBaseViewController {
    // MARK: - Properties
    var router: (NSObjectProtocol & PostingKeyShowRoutingLogic)?
    var handlerReturnComletion: (([UITextField]) -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet var textFieldsCollection: [UITextField]!
    
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.tune(withPlaceholder:        "Enter Login Placeholder",
                                textColors:             blackWhiteColorPickers,
                                font:                   UIFont.init(name: "SFProDisplay-Regular", size: 16.0 * widthRatio),
                                alignment:              .left)
            
            loginTextField.delegate     =   self
        }
    }
    
    @IBOutlet weak var postingKeyTextField: UITextField! {
        didSet {
            postingKeyTextField.tune(withPlaceholder:        "Enter Posting Key Placeholder",
                                     textColors:             veryDarkGrayWhiteColorPickers,
                                     font:                   UIFont.init(name: "SFProDisplay-Regular", size: 16.0 * widthRatio),
                                     alignment:              .left)
            
            let rightView                       =   UIView(frame: CGRect(x: 0.0, y: 0.0, width: 90.0 * widthRatio, height: postingKeyTextField.frame.height))
            postingKeyTextField.rightView       =   rightView
            postingKeyTextField.rightViewMode   =   .always

            postingKeyTextField.delegate        =   self
        }
    }

    @IBOutlet weak var postingKeyTextFieldTopConstraint: NSLayoutConstraint! {
        didSet {
            postingKeyTextFieldTopConstraint.constant *= (heightRatio < 1) ? heightRatio : 1
        }
    }
    
    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let router                  =   PostingKeyShowRouter()
        
        viewController.router       =   router
        router.viewController       =   viewController
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tune()
    }
    
    
    // MARK: - Actions
    @IBAction func scanQRButtonPressed(_ sender: Any) {
        self.router?.routeToScannerShowScene()
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        self.router?.showLoginHelpShowScene()
    }
    
    @IBAction func testDataButtonTapped(_ sender: UIButton) {
        switch appBuildConfig! {
        case .development:
            self.textFieldsCollection.first!.text   =   "yoyoyoyo"
            self.textFieldsCollection.last!.text    =   "5KUk2QMqYqpFM54YSaNoYLVDTznM3fyA8J8qDUQQNgBnqvVyscC"

        default:
            // User "destroyer2k"
//            self.textFieldsCollection.first!.text   =   "destroyer2k"
//            self.textFieldsCollection.last!.text    =   "5JjQWZmWj36xbVdcX96gjMs5BRip7TPPCNFFnm19TPEviqnG5Ke"
            
            // User "joseph.kalu"
            self.textFieldsCollection.first!.text   =   "joseph.kalu"
            self.textFieldsCollection.last!.text    =   "5K6CfG8gzhTZNwHDxPmeQiPChx6FpgiVYN7USVp2aGC2WsDqH4h"

            // User "joseph.kalu"
//            self.textFieldsCollection.first!.text   =   "nick.lick"
//            self.textFieldsCollection.last!.text    =   "5HuxaRnfHNTS4HA5EA5SQPqAZogP2GoCuZR2yuL1jdfoqjLZAFD"
        }
        
        self.handlerReturnComletion!(self.textFieldsCollection)
    }
}


// MARK: - UITextFieldDelegate
extension PostingKeyShowViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == postingKeyTextField, let text = textField.text, !text.isEmpty {
            return (text.hasPrefix("1") || text.hasPrefix("5")) ? true : false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.handlerReturnComletion!(self.textFieldsCollection)
        
        if textField == postingKeyTextField, let text = textField.text, text.count == 0 {
            return (string == "1" || string == "5" || string.hasPrefix("1") || string.hasPrefix("5")) ? true : false
        }
        
        return true
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            IQKeyboardManager.sharedManager().goNext()
            
        case postingKeyTextField:
            textField.resignFirstResponder()
            
        default:
            break
        }
        
        self.handlerReturnComletion!(self.textFieldsCollection)

        return true
    }
}
