//
//  PostShowInteractor.swift
//  golos-ios
//
//  Created by msm72 on 31.07.2018.
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
protocol PostShowBusinessLogic {
    func save(comment: PostShortInfo)
    func subscribe(withRequestModel requestModel: PostShowModels.Item.RequestModel)
    func loadPostContent(withRequestModel requestModel: PostShowModels.Post.RequestModel)
    func loadPostComments(withRequestModel requestModel: PostShowModels.Post.RequestModel)
    func checkFollowing(withRequestModel requestModel: PostShowModels.Following.RequestModel)
    func likeVote(withRequestModel requestModel: PostShowModels.Like.RequestModel)
}

protocol PostShowDataStore {
    var comment: PostShortInfo? { get set }
    var postType: PostsFeedType? { get set }
    var postShortInfo: PostShortInfo? { get set }
    var displayedPost: PostCellSupport? { get set }
}

class PostShowInteractor: PostShowBusinessLogic, PostShowDataStore {
    // MARK: - Properties
    var presenter: PostShowPresentationLogic?
    
    // PostShowDataStore protocol implementation
    var comment: PostShortInfo?
    var postType: PostsFeedType?
    var displayedPost: PostCellSupport?
    
    var postShortInfo: PostShortInfo? {
        didSet {
            if let selectedPost = CoreDataManager.instance.readEntity(withName:                   self.postType!.caseTitle().uppercaseFirst,
                                                                      andPredicateParameters:     NSPredicate(format: "id == \(self.postShortInfo!.id ?? 0)")) as? PostCellSupport {
                
                self.displayedPost = selectedPost
            }
        }
    }

    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func save(comment: PostShortInfo) {
        self.comment = comment
    }
    
    func loadPostContent(withRequestModel requestModel: PostShowModels.Post.RequestModel) {
        // API 'get_content'
        guard let author = self.postShortInfo?.author, let permlink = self.postShortInfo?.permlink else { return }
            
        let content = RequestParameterAPI.Content(author: author, permlink: permlink, active_votes: 1_000)
        
        RestAPIManager.loadPost(byContent: content, andPostType: self.postType!, completion: { [weak self] errorAPI in
            guard errorAPI?.caseInfo.message != "No Internet Connection" || !(errorAPI?.caseInfo.message.hasSuffix("timing"))! else {
                let responseModel = PostShowModels.Post.ResponseModel(errorAPI: errorAPI)
                self?.presenter?.presentLoadPostContent(fromResponseModel: responseModel)
                
                return
            }
            
            let responseModel = PostShowModels.Post.ResponseModel(errorAPI: nil)
            self?.presenter?.presentLoadPostContent(fromResponseModel: responseModel)
        })
    }

    func loadPostComments(withRequestModel requestModel: PostShowModels.Post.RequestModel) {
        // API 'get_all_content_replies'
        let content = RequestParameterAPI.Content(author: self.postShortInfo?.author ?? "XXX", permlink: self.postShortInfo?.permlink ?? "XXX", active_votes: 1_000)
        
        RestAPIManager.loadPostComments(byContent: content, andPostType: .comment, completion: { [weak self] errorAPI in
            guard errorAPI?.caseInfo.message != "No Internet Connection" || !(errorAPI?.caseInfo.message.hasSuffix("timing"))! else {
                let responseModel = PostShowModels.Post.ResponseModel(errorAPI: errorAPI)
                self?.presenter?.presentLoadPostComments(fromResponseModel: responseModel)
                
                return
            }
            
            let responseModel = PostShowModels.Post.ResponseModel(errorAPI: nil)
            self?.presenter?.presentLoadPostComments(fromResponseModel: responseModel)
        })
    }
    
    func checkFollowing(withRequestModel requestModel: PostShowModels.Following.RequestModel) {
        // API 'get_following'
        RestAPIManager.loadFollowing(byUserNickName: User.current!.nickName, authorNickName: self.postShortInfo?.author ?? "XXX", pagination: 1, completion: { [weak self] (isFollowing, errorAPI) in
            let responseModel = PostShowModels.Following.ResponseModel(isFollowing: isFollowing, errorAPI: errorAPI)
            self?.presenter?.presentCheckFollowing(fromResponseModel: responseModel)
        })
    }
    
    func subscribe(withRequestModel requestModel: PostShowModels.Item.RequestModel) {
        RestAPIManager.subscribe(up: requestModel.willSubscribe, toAuthor: self.postShortInfo!.author ?? "XXX", completion: { [weak self] errorAPI in
            let isFollowing = errorAPI == nil && requestModel.willSubscribe
            
            let responseModel = PostShowModels.Item.ResponseModel(isFollowing: isFollowing, errorAPI: errorAPI)
            self?.presenter?.presentSubscribe(fromResponseModel: responseModel)
        })
    }
    
    func likeVote(withRequestModel requestModel: PostShowModels.Like.RequestModel) {
        let postShortInfo = requestModel.forPost ? self.postShortInfo! : self.comment!
        
        RestAPIManager.vote(isLike: requestModel.isLike, isDislike: requestModel.isDislike, postShortInfo: postShortInfo, completion: { [weak self] errorAPI in
            let responseModel = PostShowModels.Like.ResponseModel(isLike: requestModel.isLike, isDislike: requestModel.isDislike, forPost: requestModel.forPost, errorAPI: errorAPI)
            self?.presenter?.presentLikeVote(fromResponseModel: responseModel)
        })
    }
}
