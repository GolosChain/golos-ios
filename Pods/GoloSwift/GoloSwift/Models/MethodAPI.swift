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
    case getAccounts(nickNames: [String])
    
    /// Displays various information about the current status of the GOLOS network.
    case getDynamicGlobalProperties()
    
    /// Displays a limited number of publications, sorted by type.
    case getDiscussions(type: PostsFeedType, parameters: RequestParameterAPI.Discussion)
    
    /// Displays current user replies
    case getUserReplies(startAuthor: String, startPermlink: String?, limit: UInt, voteLimit: UInt)
    
    /// Diplays current user followers list
    case getUserFollowers(userNickName: String, authorNickName: String, pagination: UInt)

    /// Diplays current user entries list
    case getUserBlogEntries(userNickName: String, startPagination: UInt64, pagination: UInt)
    
    /// Diplays current user follow counts
    case getUserFollowCounts(nickName: String)
    
    /// Diplays current user followings list
    case getUserFollowings(userNickName: String, authorNickName: String, pagination: UInt)
    
    /// Diplays current user follow counts
    case getContent(parameters: RequestParameterAPI.Content)
    
    /// Diplays selected user comments list
    case getContentAllReplies(parameters: RequestParameterAPI.Content)
    
    /// Diplays active vote users list
    case getActiveVotes(userNickName: String, permlink: String)

    
    /// This method return request parameters from selected enum case.
    func introduced() -> MethodRequestParameters {
        switch self {
        // GET
        case .getAccounts(let nickNames):           return  (methodAPIType:     self,
                                                             paramsFirst:       ["database_api", "get_accounts"],
                                                             paramsSecond:      nickNames)
            
        case .getDynamicGlobalProperties():         return  (methodAPIType:     self,
                                                             paramsFirst:       ["database_api", "get_dynamic_global_properties"],
                                                             paramsSecond:      nil)
            
        case .getUserFollowCounts(let userNickName):    return  (methodAPIType:     self,
                                                                 paramsFirst:       ["follow", "get_follow_count"],
                                                                 paramsSecond:      String(format: "\"%@\"", userNickName))
            
        // Template: {"id": 22, "method": "call", "jsonrpc": "2.0", "params": ["follow", "get_followers", ["nikulinsb", "atteh", "blog", 50]]}
        case .getUserFollowers(let userNickName, let authorNickName, let pagination):
            return  (methodAPIType:     self,
                     paramsFirst:       ["follow", "get_followers"],
                     paramsSecond:      String(format: "\"%@\", \"%@\", \"blog\", %i", userNickName, authorNickName, pagination))

        // Template: {"id": 19, "method": "call", "jsonrpc": "2.0", "params": ["follow", "get_blog_entries", ["joseph.kalu", 0, 200]]}
        case .getUserBlogEntries(let userNickName, let startPagination, let pagination):
            return  (methodAPIType:     self,
                     paramsFirst:       ["follow", "get_blog_entries"],
                     paramsSecond:      String(format: "\"%@\", %i, %i", userNickName, startPagination, pagination))
            
        // Template: {"id": 11, "method": "call", "jsonrpc": "2.0", "params": ["follow", "get_following", ["joseph.kalu", "bomberuss", "blog", 1]]}
        case .getUserFollowings(let userNickName, let authorNickName, let pagination):
            return  (methodAPIType:     self,
                     paramsFirst:       ["follow", "get_following"],
                     paramsSecond:      String(format: "\"%@\", \"%@\", \"blog\", %i", userNickName, authorNickName, pagination))
            
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
            
        case .getContent(let contentModel):                         return  (methodAPIType:     self,
                                                                             paramsFirst:       ["social_network", "get_content"],
                                                                             paramsSecond:      contentModel.convertToString())
            
        case .getContentAllReplies(let contentModel):               return  (methodAPIType:     self,
                                                                             paramsFirst:       ["social_network", "get_all_content_replies"],
                                                                             paramsSecond:      contentModel.convertToString())
            
        case .getActiveVotes(let userNickName, let permlink):       return  (methodAPIType:     self,
                                                                             paramsFirst:       ["social_network", "get_active_votes"],
                                                                             paramsSecond:      String(format: "\"%@\",\"%@\"", userNickName, permlink))
        } // switch
    }
}
