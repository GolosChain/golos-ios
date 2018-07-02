//
//  PostingKeyShowRouter.swift
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

// MARK: - Input & Output protocols
@objc protocol PostingKeyShowRoutingLogic {
    func showLoginHelpShowScene()
    func routeToScannerShowScene()
}

class PostingKeyShowRouter: NSObject, PostingKeyShowRoutingLogic {
    // MARK: - Properties
    weak var viewController: PostingKeyShowViewController?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func showLoginHelpShowScene() {
        let logInHelpShowVC                     =   LogInHelpShowViewController.nibInstance()
        logInHelpShowVC.modalPresentationStyle  =   .overCurrentContext
        logInHelpShowVC.loginType               =   .postingKey
        
        viewController?.present(logInHelpShowVC, animated: true, completion: nil)
    }
    
    func routeToScannerShowScene() {
        let scannerShowNC   =   UIStoryboard(name: "ScannerShow", bundle: nil).instantiateViewController(withIdentifier: "ScannerShowNC") as! UINavigationController
        
        viewController?.present(scannerShowNC, animated: true, completion: nil)
        
        // Handler QR Code
        (scannerShowNC.viewControllers.first as! ScannerShowViewController).completionDetectQRCode = { [weak self] qrCode in
            self?.viewController?.postingKeyTextField.text = qrCode
        }
    }
}
