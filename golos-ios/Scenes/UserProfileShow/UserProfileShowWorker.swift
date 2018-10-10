//
//  UserProfileShowWorker.swift
//  golos-ios
//
//  Created by msm72 on 10.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData
import GoloSwift

typealias UserProfileDetailsParams = (type: PostsFeedType, lastItem: NSManagedObject?)

class UserProfileShowWorker {
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business Logic
    func prepareRequestMethod(byUserNickName userNickName: String, andParameters parameters: UserProfileDetailsParams) -> MethodAPIType {
        var methodAPIType: MethodAPIType
        let lastItem = parameters.lastItem
        
        switch parameters.type {
        // Replies
        case .reply:
            methodAPIType = MethodAPIType.getUserReplies(startAuthor:       (lastItem as? Reply)?.author ?? userNickName,
                                                         startPermlink:     (lastItem as? Reply)?.permlink,
                                                         limit:             loadDataLimit,
                                                         voteLimit:         1000)

        // Blogs
        default:
            let discussion = RequestParameterAPI.Discussion.init(limit:             loadDataLimit,
                                                                 truncateBody:      0,
                                                                 selectAuthors:     [ userNickName ],
                                                                 startAuthor:       (lastItem as? PostCellSupport)?.author,
                                                                 startPermlink:     (lastItem as? PostCellSupport)?.permlink,
                                                                 voteLimit:         1000)
            
            methodAPIType = MethodAPIType.getDiscussions(type: parameters.type, parameters: discussion)
        }
        
        return methodAPIType
    }
}
