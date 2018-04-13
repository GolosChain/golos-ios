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
typealias RequestParametersType = (paramsFirst: [String], paramsSecond: JSON?)

/// API methods.
public enum MethodApiType {
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
        case .getDiscussionsByHot(let limit):       return (paramsFirst:        ["social_network", "get_discussions_by_hot"],
                                                            paramsSecond:       ["limit":limit])
            
        case .getDiscussionsByCreated(let limit):   return (paramsFirst:        ["social_network", "get_discussions_by_created"],
                                                            paramsSecond:       ["limit":limit])
            
        case .getDiscussionsByTrending(let limit):  return (paramsFirst:        ["social_network", "get_discussions_by_trending"],
                                                            paramsSecond:       ["limit":limit])

        case .getDiscussionsByPromoted(let limit):  return (paramsFirst:        ["social_network", "get_discussions_by_promoted"],
                                                            paramsSecond:       ["limit":limit])

        }
    }
}
