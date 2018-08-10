//
//  MethodAPI.swift
//  GoloSwift
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//
//  This enum use for GET Requests
//

import Foundation
import BeyovaJSON

/// Type of request parameters
typealias MethodRequestParameters = (methodAPIType: MethodAPIType, paramsFirst: [String], paramsSecond: Encodable?)

/// API GET methods
public indirect enum MethodAPIType {
    /// Displays information about the users specified in the request.
    case getAccounts(names: [String])
    
    /// Displays various information about the current status of the GOLOS network.
    case getDynamicGlobalProperties()
    
    /// Displays a limited number of publications, sorted by type.
    case getDiscussions(type: PostsFeedType, parameters: RequestParameterAPI.Discussion)
    
    /// Displays current user replies
    case getUserReplies(startAuthor: String, startPermlink: String?, limit: UInt, voteLimit: UInt)
    
    /// Diplays current user follow counts
    case getUserFollowCounts(name: String)
    
    /// Diplays current user follow counts
    case getContent(parameters: RequestParameterAPI.Content)
    
    /// Diplays selected user comments list
    case getContentAllReplies(parameters: RequestParameterAPI.Content)
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> MethodRequestParameters {
        switch self {
        // GET
        case .getAccounts(let names):                       return  (methodAPIType:     self,
                                                                     paramsFirst:       ["database_api", "get_accounts"],
                                                                     paramsSecond:      names)
            
        case .getDynamicGlobalProperties():                 return  (methodAPIType:     self,
                                                                     paramsFirst:       ["database_api", "get_dynamic_global_properties"],
                                                                     paramsSecond:      nil)
            
        case .getUserFollowCounts(let userName):            return  (methodAPIType:     self,
                                                                     paramsFirst:       ["follow", "get_follow_count"],
                                                                     paramsSecond:      String(format: "\"%@\"", userName))
            
        case .getUserReplies(let startAuthor, let startPermlink, let limit, let voteLimit):
            var secondParameters: String
            
            if let permlink = startPermlink {
                secondParameters    =   String(format: "\"%@\",\"%@\",%i,%i", startAuthor, permlink, limit, voteLimit)
            }
                
            else {
                secondParameters    =   String(format: "\"%@\",\"\",%i,%i", startAuthor, limit, voteLimit)
            }
            
            return  (methodAPIType:      self,
                     paramsFirst:        ["social_network", "get_replies_by_last_update"],
                     paramsSecond:       secondParameters)
            
        case .getDiscussions(let type, let discussion):
            let parameterAPI = (appBuildConfig == AppBuildConfig.debug) ? "tags" : "tags"
            
            return (methodAPIType:      self,
                    paramsFirst:        [parameterAPI, type.caseAPIParameters()],
                    paramsSecond:       discussion)
            
        case .getContent(let contentModel):                 return  (methodAPIType:     self,
                                                                     paramsFirst:       ["social_network", "get_content"],
                                                                     paramsSecond:      contentModel.convertToString())
            
        case .getContentAllReplies(let contentModel):       return  (methodAPIType:     self,
                                                                     paramsFirst:       ["social_network", "get_all_content_replies"],
                                                                     paramsSecond:      contentModel.convertToString())
        } // switch
    }
}

