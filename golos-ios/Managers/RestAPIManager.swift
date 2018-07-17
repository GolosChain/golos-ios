//
//  RestAPIManager.swift
//  Golos
//
//  Created by msm72 on 12.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

class RestAPIManager {
    // MARK: - Class Functions
    
    /// Load list of Users
    class func loadUsersInfo(byNames names: [String], completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_accounts'
        if isNetworkAvailable {
            let methodAPIType   =   MethodAPIType.getAccounts(names: names)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserResult).result, result.count > 0 else {
                                        completion(ErrorAPI.requestFailed(message: names.count == 1 ? "User is not found" : "List of users is empty"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entities
                                    _ = result.map({
                                        let userEntity = User.instance(byUserID: $0.id)
                                        userEntity.updateEntity(fromResponseAPI: $0)
                                        
                                        // Set User isAuthorized
                                        if names.count == 1 {
                                            User.fetch(byName: names.first!)?.setIsAuthorized(true)
                                        }
                                    })
                                    
                                    completion(nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
        
        // Offline mode
        else {
            completion(nil)
        }
    }

    
    /// Load list of PostFeed
    class func loadPostsFeed(byMethodAPIType methodAPIType: MethodAPIType, andPostFeedType postFeedType: PostsFeedType, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_discussions_by_blog' & 'get_replies_by_last_update'
        if isNetworkAvailable {
            print("methodAPIType = \(methodAPIType)")
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIFeedResult).result, result.count > 0 else {
                                        completion(nil)
                                        return
                                    }
                                    
                                    // CoreData: Update Post entities by type
                                    _ = result.map({ responseAPIFeed in
                                        switch postFeedType {
                                        // Reply
                                        case .reply:
                                            Reply.updateEntity(fromResponseAPI: responseAPIFeed)
                                            
                                        // Popular
                                        case .popular:
                                            Popular.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Actual
                                        case .actual:
                                            Actual.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // New
                                        case .new:
                                            New.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Promo
                                        case .promo:
                                            Promo.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Current user Lenta (blogs)
                                        default:
                                            Lenta.updateEntity(fromResponseAPI: responseAPIFeed)
                                        }
                                    })
                                    
                                    // Load authors info
                                    loadUsersInfo(byNames: Array(Set(result.compactMap({ $0.author }))), completion: { errorAPI in
                                        completion(errorAPI)
                                    })
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
        
        // Offline mode
        else {
            completion(nil)
        }
    }
    
    
    /// Load User Follow counts
    class func loadUserFollowCounts(byName name: String, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_follow_count'
        if isNetworkAvailable {
            let methodAPIType   =   MethodAPIType.getUserFollowCounts(name: name)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserFollowCountsResult).result else {
                                        completion(ErrorAPI.requestFailed(message: "User follow counts are not found"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entity
                                    if let user = User.fetch(byName: name) {
                                        user.updateEntity(fromResponseAPI: result)
                                    }
                                    
                                    completion(nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(nil)
        }
    }
}
