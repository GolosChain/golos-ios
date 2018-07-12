//
//  LogInShowInteractor.swift
//  golos-ios
//
//  Created by msm72 on 12.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Business Logic protocols
protocol LogInShowBusinessLogic {
    func authorizeUser(withRequestModel requestModel: LogInShowModels.Parameters.RequestModel)
}

class LogInShowInteractor: LogInShowBusinessLogic {
    // MARK: - Properties
    var presenter: LogInShowPresentationLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func authorizeUser(withRequestModel requestModel: LogInShowModels.Parameters.RequestModel) {
        // AP 'get_accounts'
        RestAPIManager.loadUsersInfo(byNames: [requestModel.userName], completion: { [weak self] errorAPI in
            var success: Bool   =   false
            
            // Prepare & Display user info
            if errorAPI == nil {
                let privateKey  =   PrivateKey.init(requestModel.wif)
                let publicKey   =   privateKey!.createPublic(prefix: .mainNet)
                
                switch requestModel.wifType {
                // Posting key
                case 1:
                    success     =   (User.current?.posting?.key_auths?.first?.first?.contains(publicKey.address))!
                    
                // Active key
                case 2:
                    success     =   (User.current?.active?.key_auths?.first?.first?.contains(publicKey.address))!
                    
                default:
                    break
                }
                
                // Save Private key in Keychain
                if success {
                    _ = KeychainManager.save(requestModel.wif, forUserName: requestModel.userName)
                }
            }
            
            let responseModel = LogInShowModels.Parameters.ResponseModel(success: success)
            self?.presenter?.presentAuthorizeUser(fromResponseModel: responseModel)
        })
    }
}
