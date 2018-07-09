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
import CoreData
import GoloSwift

// MARK: - Business Logic protocols
protocol UserProfileShowBusinessLogic {
    func loadUserInfo(withRequestModel requestModel: UserProfileShowModels.UserInfo.RequestModel)
    func loadUserBlogDetails(withRequestModel requestModel: UserProfileShowModels.UserDetails.RequestModel)
}

protocol UserProfileShowDataStore {}

class UserProfileShowInteractor: UserProfileShowBusinessLogic, UserProfileShowDataStore {
    // MARK: - Properties
    var presenter: UserProfileShowPresentationLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func loadUserInfo(withRequestModel requestModel: UserProfileShowModels.UserInfo.RequestModel) {
        // API 'get_accounts'
        if isNetworkAvailable {
            // Create MethodAPIType
            let names           =   User.current!.name
            let methodAPIType   =   MethodAPIType.getAccounts(names: RequestParameterAPI.User(names: [names]))
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { [weak self] responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let userResult = (responseAPIResult as! ResponseAPIUserResult).result, userResult.count > 0 else {
                                        // Send empty User info
                                        let responseModel = UserProfileShowModels.UserInfo.ResponseModel(error: nil)
                                        self?.presenter?.presentUserInfo(fromResponseModel: responseModel)
                                        
                                        return
                                    }
                                    
                                    // Update User entity
                                    if let userResponseAPI = userResult.first {
                                        let userEntity              =   User.instance(byUserID: userResponseAPI.id)
                                        userEntity.isAuthorized     =   true
                                        userEntity.updateEntity(fromResponseAPI: userResponseAPI)
                                    }
                                    
                                    // Send User info
                                    let responseModel = UserProfileShowModels.UserInfo.ResponseModel(error: nil)
                                    self?.presenter?.presentUserInfo(fromResponseModel: responseModel)
                },
                                 onError: { [weak self] errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    
                                    // Send error
                                    let responseModel = UserProfileShowModels.UserInfo.ResponseModel(error: errorAPI)
                                    self?.presenter?.presentUserInfo(fromResponseModel: responseModel)
            })
        }
    }
    
    func loadUserBlogDetails(withRequestModel requestModel: UserProfileShowModels.UserDetails.RequestModel) {
        // API 'get_discussions_by_blog'
        if isNetworkAvailable {
            // Create MethodAPIType
            let discussion      =   RequestParameterAPI.Discussion.init(limit:          loadDataLimit,
                                                                        truncateBody:   0,
                                                                        selectAuthors:  [ User.current!.name ])

            let methodAPIType   =   MethodAPIType.getDiscussions(type: .lenta, parameters: discussion)
            
            // API 'get_discussions_by_blog'
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { [weak self] responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIFeedResult).result, result.count > 0 else {
                                        // Send User info
                                        let userDetailsResponseModel = UserProfileShowModels.UserDetails.ResponseModel(error: nil)
                                        self?.presenter?.presentUserBlogDetails(fromResponseModel: userDetailsResponseModel)

                                        return
                                    }
                                    
                                    // Update User blog entity
//                                    if let userEntity = CoreDataManager.instance.createEntity("User") as? User {
//                                        userEntity.updateEntity(fromResponseAPI: userResult.first)
//
//                                        // Send User info
//                                        let userDetailsResponseModel = UserProfileShowModels.UserDetails.ResponseModel(error: nil)
//                                        self?.presenter?.presentUserDetails(fromResponseModel: userDetailsResponseModel)
//                                    }

//                                    let displayedPosts = result.compactMap({ DisplayedPost(fromResponseAPIFeed: $0) })
            },
                                 onError: { [weak self] errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)

                                    // Send error
                                    let userDetailsResponseModel = UserProfileShowModels.UserDetails.ResponseModel(error: errorAPI)
                                    self?.presenter?.presentUserBlogDetails(fromResponseModel: userDetailsResponseModel)
            })
        }
    }
}
