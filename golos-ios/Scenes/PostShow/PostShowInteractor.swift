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
    func save(post: PostShortInfo)
    func save(comment: PostShortInfo)
    func loadContent(withRequestModel requestModel: PostShowModels.Post.RequestModel)
    func loadContentComments(withRequestModel requestModel: PostShowModels.Post.RequestModel)
}

protocol PostShowDataStore {
    var post: PostShortInfo? { get set }
    var comment: PostShortInfo? { get set }
    var postType: PostsFeedType? { get set }
}

class PostShowInteractor: PostShowBusinessLogic, PostShowDataStore {
    // MARK: - Properties
    var presenter: PostShowPresentationLogic?
    var worker: PostShowWorker?
    
    // PostShowDataStore protocol implementation
    var post: PostShortInfo?
    var comment: PostShortInfo?
    var postType: PostsFeedType?
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func save(post: PostShortInfo) {
        self.post       =   post
    }

    func save(comment: PostShortInfo) {
        self.comment    =   comment
    }
    
    func loadContent(withRequestModel requestModel: PostShowModels.Post.RequestModel) {
        // API 'get_content'
        let content = RequestParameterAPI.Content(author: (self.post as! PostCellSupport).author, permlink: (self.post as! PostCellSupport).permlink)
        
        RestAPIManager.loadPost(byContent: content, andPostType: self.postType!, completion: { [weak self] errorAPI in
            guard errorAPI?.caseInfo.message != "No Internet Connection" || !(errorAPI?.caseInfo.message.hasSuffix("timing"))! else {
                let responseModel = PostShowModels.Post.ResponseModel(errorAPI: errorAPI)
                self?.presenter?.presentLoadContent(fromResponseModel: responseModel)
                
                return
            }
            
            let responseModel = PostShowModels.Post.ResponseModel(errorAPI: nil)
            self?.presenter?.presentLoadContent(fromResponseModel: responseModel)
        })
    }

    func loadContentComments(withRequestModel requestModel: PostShowModels.Post.RequestModel) {
//        worker = PostShowWorker()
//        worker?.doSomeWork()
        
        // API 'get_all_content_replies'
        let content = RequestParameterAPI.Content(author: (self.post as! PostCellSupport).author, permlink: (self.post as! PostCellSupport).permlink)
        
        RestAPIManager.loadPostComments(byContent: content, andPostType: .comment, completion: { [weak self] errorAPI in
            guard errorAPI?.caseInfo.message != "No Internet Connection" || !(errorAPI?.caseInfo.message.hasSuffix("timing"))! else {
                let responseModel = PostShowModels.Post.ResponseModel(errorAPI: errorAPI)
                self?.presenter?.presentLoadContentComments(fromResponseModel: responseModel)
                
                return
            }
            
            let responseModel = PostShowModels.Post.ResponseModel(errorAPI: nil)
            self?.presenter?.presentLoadContentComments(fromResponseModel: responseModel)
        })
    }
}
