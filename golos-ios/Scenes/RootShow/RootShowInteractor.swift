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
    func loadPosts(withRequestModel requestModel: RootShowModels.Items.RequestModel)
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
    func loadPosts(withRequestModel requestModel: RootShowModels.Items.RequestModel) {
        // API 'get_discussions_by_trending' or 'get_discussions_by_blog'
        // FIXME: - ADD USER STATE CHECK & USER NAME
        let type        =   (2/3 == 1) ?    PostsFeedType.popular : PostsFeedType.lenta
        
        let discussion  =   (2/3 == 1) ?    RequestParameterAPI.Discussion.init(limit:          loadDataLimit) :
                                            RequestParameterAPI.Discussion.init(limit:          loadDataLimit,
                                                                                truncateBody:   0,
                                                                                selectAuthors:  ["yuri-vlad-second"])
        
        PostsFeedManager().loadPostsFeed(withType: type, andDiscussion: discussion, completion: { [weak self] (items, errorAPI) in
            guard let selfStrong = self else { return }
            
            guard errorAPI == nil else {
//                Utils.showAlertView(withTitle: errorAPI!.caseInfo.title, andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
                return
            }
            
            guard items!.count > 0 else {
                return
            }
            
            // Prepare & Display feed posts
            displayedPostsItems.append(contentsOf: items!)

            let responseModel = RootShowModels.Items.ResponseModel()
            selfStrong.presenter?.presentPosts(fromResponseModel: responseModel)
        })
    }
}
