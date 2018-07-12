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

typealias UserProfileDetailsParams    =   (type: PostsFeedType, lastLentaPost: Lenta?, lastReplyPost: Reply?)

class UserProfileShowWorker {
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business Logic
    func prepareRequestMethod(_ parameters: UserProfileDetailsParams) -> MethodAPIType {
        var methodAPIType: MethodAPIType
        
        switch parameters.type {
        // Replies
        case .reply:
            methodAPIType   =   MethodAPIType.getUserReplies(startAuthor:           User.current!.name,
                                                             startPermlink:         parameters.lastReplyPost?.permlink,
                                                             limit:                 loadDataLimit,
                                                             voteLimit:             0)

        // Lenta (blogs)
        default:
            let discussion  =   RequestParameterAPI.Discussion.init(limit:          loadDataLimit,
                                                                    truncateBody:   0,
                                                                    selectAuthors:  [ User.current!.name ],
                                                                    startAuthor:    parameters.lastLentaPost?.author,
                                                                    startPermlink:  parameters.lastLentaPost?.permlink)
            
            methodAPIType   =   MethodAPIType.getDiscussions(type: .lenta, parameters: discussion)
        }
        
        return methodAPIType
    }
}
