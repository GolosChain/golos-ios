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
typealias RequestParametersType = (methodAPIType: MethodAPIType, paramsFirst: [String], paramsSecond: Encodable?)

/// API methods.
public enum MethodAPIType {
    /// Displays information about the users specified in the request.
    case getAccounts(names: [String])
    
    /// Displays various information about the current status of the GOLOS network.
    case getDynamicGlobalProperties()
    
    /// Displays a limited number of publications, sorted by type.
    case getDiscussions(type: PostsFeedType, parameters: RequestParameterAPI.Discussion)
    
    ///
    case getAllContentReplies(author: String, permlink: String)
    
    /// Displays current user replies
    case getUserReplies(startAuthor: String, startPermlink: String?, limit: UInt, voteLimit: UInt)
    
    /// Diplays current user follow counts
    case getUserFollowCounts(name: String)

    /// Save `vote` to blockchain
    case verifyAuthorityVote
    
    // Post: create, add comment & comment reply
    case post(action: PostActionType, parameters: RequestParameterAPI.Comment)
    
    // Create new post comment
    //    case createPostComment(parameters: RequestParameterAPI.Discussion)
    //
    //    // Reply for post comment
    //    case replyPostComment(parameters: RequestParameterAPI.Discussion)
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> RequestParametersType {
        switch self {
        // GET
        case .getAccounts(let names):                       return  (methodAPIType:      self,
                                                                     paramsFirst:        ["database_api", "get_accounts"],
                                                                     paramsSecond:       names)
            
        case .getDynamicGlobalProperties():                 return  (methodAPIType:      self,
                                                                     paramsFirst:        ["database_api", "get_dynamic_global_properties"],
                                                                     paramsSecond:       nil)
            
        case .getUserFollowCounts(let userName):            return  (methodAPIType:      self,
                                                                     paramsFirst:        ["follow", "get_follow_count"],
                                                                     paramsSecond:       String(format: "\"%@\"", userName))

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
            // {"id":72,"method":"call","jsonrpc":"2.0","params":["tags","get_discussions_by_hot",[{"limit":20,"truncate_body":1024,"filter_tags":["test","bm-open","bm-ceh23","bm-tasks","bm-taskceh1"]}]]}
            //            var parametersBody: JSON           =   [["limit": discussion.limit], ["truncate_body": discussion.truncateBody!]]
            
            //            let truncate_body: UInt                     =   truncateBody ?? 1024
            //            parametersBody["truncate_body"]             =   truncate_body
            //
            //            if let select_tags = selectTags {
            //                parametersBody["select_tags"]           =   select_tags
            //            }
            //
            //            if let filter_tags = filterTags {
            //                parametersBody["filter_tags"]           =   filter_tags
            //            }
            //
            //            if let select_languages = selectLanguages {
            //                parametersBody["select_languages"]      =   select_languages
            //            }
            //
            //            if let filter_languages = filterLanguages {
            //                parametersBody["filter_languages"]      =   filter_languages
            //            }
            //
            //            if let select_authors = selectAuthors {
            //                parametersBody["select_authors"]        =   select_authors
            //            }
            //
            //            if let start_author = startAuthor {
            //                parametersBody["start_author"]          =   start_author
            //            }
            //
            //            if let start_permlink = startPermlink {
            //                parametersBody["start_permlink"]        =   start_permlink
            //            }
            //
            //            if let parent_permlink = parentPermlink {
            //                parametersBody["parent_permlink"]        =   parent_permlink
            //            }
            //
            //            if let parent_author = parentAuthor {
            //                parametersBody["parent_author"]         =   parent_author
            //            }
            
            let parameterAPI = (appBuildConfig == AppBuildConfig.Debug) ? "tags" : "tags"
            
            return (methodAPIType:      self,
                    paramsFirst:        [parameterAPI, type.caseAPIParameters()],
                    paramsSecond:       discussion)
            
        // {"id": 278, "method": "call", "jsonrpc": "2.0", "params": ["social_network", "get_all_content_replies", ["psk", "psk01061"]]}
        case .getAllContentReplies(let author, let permlink):       return (methodAPIType:      self,
                                                                            paramsFirst:        ["social_network", "get_all_content_replies"],
                                                                            paramsSecond:       String(format: "\"%@\", \"%@\"", author, permlink))
            
            
        // POST
        case .verifyAuthorityVote:                          return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "verify_authority"],
                                                                    paramsSecond:       nil)
            
        case .post(_, let parameters):                      return (methodAPIType:      self,
                                                                    paramsFirst:        ["network_broadcast_api", "broadcast_transaction"],
                                                                    paramsSecond:       parameters)
            
        }
    }
}
