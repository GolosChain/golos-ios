//
//  UserProfileShowInteractor.swift
//  golos-ios
//
//  Created by msm72 on 29.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Business Logic protocols
protocol UserProfileShowBusinessLogic {
    func loadUserProfile(withRequestModel requestModel: UserProfileShowModels.User.RequestModel)
}

protocol UserProfileShowDataStore {
//     var name: String { get set }
}

class UserProfileShowInteractor: UserProfileShowBusinessLogic, UserProfileShowDataStore {
    // MARK: - Properties
    var presenter: UserProfileShowPresentationLogic?
    
    // ... protocol implementation
//    var name: String = ""
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func loadUserProfile(withRequestModel requestModel: UserProfileShowModels.User.RequestModel) {
        // API 'get_accounts'
        if isNetworkAvailable {
            // Create MethodAPIType
            let names           =   User.current?.name ?? "yuri-vlad-second"
            let methodAPIType   =   MethodAPIType.getAccounts(names: RequestParameterAPI.User(names: [names]))
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { [weak self] responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let userResult = (responseAPIResult as! ResponseAPIUserResult).result, userResult.count > 0 else {
                                        // Send empry User profile
                                        let responseModel = UserProfileShowModels.User.ResponseModel(userResult: [], error: nil)
                                        self?.presenter?.presentUserProfile(fromResponseModel: responseModel)
                                        
                                        return
                                    }
                                    
                                    // Update User entity
                                    if let userEntity = CoreDataManager.instance.createEntity("User") as? User {
                                        userEntity.updateEntity(fromResponseAPI: userResult.first)
                                    }

//                                    let displayedUsers = result.compactMap({ DisplayedUser(fromResponseAPIUser: $0) })
                                    // Send User profile
                                    let responseModel = UserProfileShowModels.User.ResponseModel(userResult: userResult, error: nil)
                                    self?.presenter?.presentUserProfile(fromResponseModel: responseModel)
                },
                                 onError: { [weak self] errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    
                                    // Send error
                                    let responseModel = UserProfileShowModels.User.ResponseModel(userResult: nil, error: errorAPI)
                                    self?.presenter?.presentUserProfile(fromResponseModel: responseModel)
            })
        }
        
        // CoreData
        else {
            
        }
    }
}
