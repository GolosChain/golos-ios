//
//  RootShowInteractor.swift
//  golos-ios
//
//  Created by msm72 on 02.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Business Logic protocols
protocol RootShowBusinessLogic {
//    func loadPosts(withRequestModel requestModel: RootShowModels.Items.RequestModel)
}

protocol RootShowDataStore {}

class RootShowInteractor: RootShowBusinessLogic, RootShowDataStore {
    // MARK: - Properties
    var presenter: RootShowPresentationLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
//    func loadPosts(withRequestModel requestModel: RootShowModels.Items.RequestModel) {
//        // API 'get_discussions_by_trending' or 'get_discussions_by_blog'
//        let type        =   (User.current == nil) ?     PostsFeedType.popular : PostsFeedType.lenta
//        
//        let discussion  =   (User.current == nil) ?     RequestParameterAPI.Discussion.init(limit:          loadDataLimit) :
//                                                        RequestParameterAPI.Discussion.init(limit:          loadDataLimit,
//                                                                                            truncateBody:   0,
//                                                                                            selectAuthors:  [ User.current!.name ])
//        
//        RestAPIManager.loadPostsFeed(byMethodAPIType: MethodAPIType.getDiscussions(type: type, parameters: discussion), andPostFeedType: type, completion: { [weak self] errorAPI in
//            let responseModel = RootShowModels.Items.ResponseModel(error: errorAPI)
//            self?.presenter?.presentPosts(fromResponseModel: responseModel)
//        })
//    }
}
