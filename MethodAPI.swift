//
//  MethodAPI.swift
//  Golos
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import BeyovaJSON

/// Type of request parameters
typealias RequestParametersType = (methodAPIType: MethodAPIType, paramsFirst: [String], paramsSecond: JSON?)

/// API methods.
public enum MethodAPIType {
    /// Verify transaction before save to blockchain
    case verifyAuthorityVote()
    
    /// Displays information about the users specified in the request.
    case getAccounts(names: [String])

    /// Displays various information about the current status of the GOLOS network.
    case getDynamicGlobalProperties()
    
    /// Displays a limited number of publications, sorted by popularity.
    case getDiscussionsByHot(limit: Int)

    /// Displays a limited number of publications, starting with the newest.
    case getDiscussionsByCreated(limit: Int)

    /// Displays a limited number of publications beginning with the most expensive of the award.
    case getDiscussionsByTrending(limit: Int)

    /// Displays a limited number of publications sorted by an increased balance amount.
    case getDiscussionsByPromoted(limit: Int)

    
    /// This method return request parameters from selected enum case.
    func introduced() -> RequestParametersType {
        switch self {
        case .verifyAuthorityVote():                        return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "verify_authority"],
                                                                    paramsSecond:       ["nil"])
            
        case .getAccounts(let names):                       return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "get_accounts"],
                                                                    paramsSecond:       [names])
            
        case .getDynamicGlobalProperties():                 return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "get_dynamic_global_properties"],
                                                                    paramsSecond:       ["nil"])
            
        case .getDiscussionsByHot(let limit):               return (methodAPIType:      self,
                                                                    paramsFirst:        ["social_network", "get_discussions_by_hot"],
                                                                    paramsSecond:       ["limit":limit])

        case .getDiscussionsByCreated(let limit):           return (methodAPIType:      self,
                                                                    paramsFirst:        ["social_network", "get_discussions_by_created"],
                                                                    paramsSecond:       ["limit":limit])
            
        case .getDiscussionsByTrending(let limit):          return (methodAPIType:      self,
                                                                    paramsFirst:        ["social_network", "get_discussions_by_trending"],
                                                                    paramsSecond:       ["limit":limit])
            
        case .getDiscussionsByPromoted(let limit):          return (methodAPIType:      self,
                                                                    paramsFirst:        ["social_network", "get_discussions_by_promoted"],
                                                                    paramsSecond:       ["limit":limit])

        }
    }
}
