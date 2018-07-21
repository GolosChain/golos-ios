////
////  PostsFeedManager.swift
////  Golos
////
////  Created by Grigory on 15/02/2018.
////  Copyright © 2018 golos. All rights reserved.
////
//
//import Foundation
//import GoloSwift
//
//class PostsFeedManager {
//    // MARK: - Custom Functions
//    /**
//     This method load posts by Feed type.
//     
//     - Parameter type: The case value of Feed type.
//     - Parameter limit: The limit value.
//     - Parameter completion: Contains two values:
//     - Parameter displayedPosts: Array of `DisplayedPost`.
//     - Parameter errorAPI: Type `ErrorAPI`.
//
//     */
//    func loadPostsFeed(withType type: PostsFeedType, andDiscussion discussion: RequestParameterAPI.Discussion, completion: @escaping ((_ displayedPosts: [DisplayedPost]?, _ errorAPI: ErrorAPI?) -> Void)) {
//        Logger.log(message: "Success", event: .severe)
//        
//        // Create MethodAPIType
//        let methodAPIType = MethodAPIType.getDiscussions(type: type, parameters: discussion)
//        
//        // API 'get_discussions_by_' 4 types
//        broadcast.executeGET(byMethodAPIType: methodAPIType,
//                             onResult: { responseAPIResult in
////                                Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
//                                
//                                guard let result = (responseAPIResult as! ResponseAPIFeedResult).result, result.count > 0 else {
//                                    completion([], nil)
//                                    return
//                                }
//                                
//                                let displayedPosts = result.compactMap({ DisplayedPost(fromResponseAPIFeed: $0) })
//                                completion(displayedPosts, nil)
//            },
//                             onError: { errorAPI in
//                                Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
//                                completion(nil, errorAPI)
//        })
//    }
//}
