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
    func save(blogShortInfo: PostShortInfo)
    func save(lastItem: NSManagedObject?)
    func save(commentReply: PostShortInfo)
    func loadUserInfo(withRequestModel requestModel: UserProfileShowModels.UserInfo.RequestModel)
    func loadUserDetails(withRequestModel requestModel: UserProfileShowModels.UserDetails.RequestModel)
    func upvote(withRequestModel requestModel: UserProfileShowModels.ActiveVote.RequestModel)
}

protocol UserProfileShowDataStore {
    var userNickName: String? { get set }
    var lastItem: NSManagedObject? { get set }
    var commentReply: PostShortInfo? { get set }
    var selectedBlog: PostShortInfo? { get set }
}

class UserProfileShowInteractor: UserProfileShowBusinessLogic, UserProfileShowDataStore {
    // MARK: - Properties
    var presenter: UserProfileShowPresentationLogic?
    var worker: UserProfileShowWorker?

    
    // MARK: - UserProfileShowDataStore implementation
    var userNickName: String? = User.current?.nickName
    var lastItem: NSManagedObject?
    var commentReply: PostShortInfo?
    var selectedBlog: PostShortInfo?

    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func save(blogShortInfo: PostShortInfo) {
        self.selectedBlog   =   blogShortInfo
    }
    
    func save(lastItem: NSManagedObject?) {
        self.lastItem       =   lastItem
    }
    
    func save(commentReply: PostShortInfo) {
        self.commentReply   =   commentReply
    }

    func loadUserInfo(withRequestModel requestModel: UserProfileShowModels.UserInfo.RequestModel) {
        RestAPIManager.loadUsersInfo(byNickNames: [self.userNickName ?? "XXX"], completion: { errorAPI in
            if errorAPI == nil {
                RestAPIManager.loadUserFollowCounts(byNickName: self.userNickName ?? "XXX", completion: { [weak self] error in
                    let userInfoResponseModel = UserProfileShowModels.UserInfo.ResponseModel(error: errorAPI)
                    self?.presenter?.presentUserInfo(fromResponseModel: userInfoResponseModel)
                })
            }
        })
    }
    
    func loadUserDetails(withRequestModel requestModel: UserProfileShowModels.UserDetails.RequestModel) {
        worker = UserProfileShowWorker()

        if let methodAPIType = worker?.prepareRequestMethod(byUserNickName: self.userNickName ?? "", andParameters: (type: requestModel.postFeedType, lastItem: self.lastItem)) {
            RestAPIManager.loadPostsFeed(byMethodAPIType: methodAPIType, andPostFeedType: requestModel.postFeedType, completion: { [weak self] errorAPI in
                let userDetailsResponseModel = UserProfileShowModels.UserDetails.ResponseModel(error: errorAPI)
                self?.presenter?.presentUserDetails(fromResponseModel: userDetailsResponseModel)
            })
        }
    }
    
    func upvote(withRequestModel requestModel: UserProfileShowModels.ActiveVote.RequestModel) {
        RestAPIManager.vote(up: requestModel.isUpvote, postShortInfo: self.selectedBlog!, completion: { [weak self] errorAPI in
            let responseModel = UserProfileShowModels.ActiveVote.ResponseModel(isUpvote: requestModel.isUpvote, errorAPI: errorAPI)
            self?.presenter?.presentUpvote(fromResponseModel: responseModel)
        })
    }
}
