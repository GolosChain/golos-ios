//
//  PostsShowInteractor.swift
//  golos-ios
//
//  Created by msm72 on 16.07.2018.
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
protocol PostsShowBusinessLogic {
    func save(post: PostShortInfo)
    func save(lastItem: NSManagedObject?)
    func loadPosts(withRequestModel requestModel: PostsShowModels.Items.RequestModel)
}

protocol PostsShowDataStore {
    var lastItem: NSManagedObject? { get set }
    var post: PostShortInfo? { get set }
}

class PostsShowInteractor: PostsShowBusinessLogic, PostsShowDataStore {
    // MARK: - Properties
    var presenter: PostsShowPresentationLogic?
    var worker: PostsShowWorker?
    
    // MARK: - PostsShowDataStore implementation
    var lastItem: NSManagedObject?
    var post: PostShortInfo?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func save(post: PostShortInfo) {
        self.post       =   post
    }
    
    func save(lastItem: NSManagedObject?) {
        self.lastItem   =   lastItem
    }
    
    func loadPosts(withRequestModel requestModel: PostsShowModels.Items.RequestModel) {
        worker = PostsShowWorker()
        
        if let methodAPIType = self.worker?.prepareRequestMethod((type: requestModel.postFeedType, lastItem: self.lastItem)) {
            RestAPIManager.loadPostsFeed(byMethodAPIType: methodAPIType, andPostFeedType: requestModel.postFeedType, completion: { [weak self] errorAPI in
                let loadPostsResponseModel = PostsShowModels.Items.ResponseModel(error: errorAPI)
                self?.presenter?.presentLoadPosts(fromResponseModel: loadPostsResponseModel)
            })
        }
    }
}
