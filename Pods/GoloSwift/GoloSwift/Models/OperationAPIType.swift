//
//  Operations.swift
//  GoloSwift
//
//  Created by msm72 on 22.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//
//  Operation types & codes:
//  https://github.com/GolosChain/golos/issues/259
//
//  This enum use for POST Requests
//

import Foundation

/// Operation types
public indirect enum OperationAPIType {
    /// In Work
    case vote(fields: RequestParameterAPI.Vote)
    case comment(fields: RequestParameterAPI.Comment)
    case commentOptions(fields: RequestParameterAPI.CommentOptions)
    case createPost(comment: OperationAPIType, commentOptions: OperationAPIType, vote: OperationAPIType)
    
    
    /// In Reserve
    /*
     case transfer_operation
     case transfer_to_vesting_operation
     case withdraw_vesting_operation
     case limit_order_create_operation
     case limit_order_cancel_operation
     case feed_publish_operation
     case convert_operation
     case account_create_operation
     case account_update_operation
     case witness_update_operation
     case account_witness_vote_operation
     case account_witness_proxy_operation
     case pow_operation
     case custom_operation
     case report_over_production_operation
     case delete_comment_operation
     case custom_json_operation
     case comment_options_operation
     case set_withdraw_vesting_route_operation
     case limit_order_create2_operation
     case challenge_authority_operation
     case prove_authority_operation
     case request_account_recovery_operation
     case recover_account_operation
     case change_recovery_account_operation
     case escrow_transfer_operation
     case escrow_dispute_operation
     case escrow_release_operation
     case pow2_operation
     case escrow_approve_operation
     case transfer_to_savings_operation
     case transfer_from_savings_operation
     case cancel_transfer_from_savings_operation
     case custom_binary_operation
     case decline_voting_rights_operation
     case reset_account_operation
     case set_reset_account_operation
     
     /// virtual operations below this point
     case fill_convert_request_operation
     case author_reward_operation
     case curation_reward_operation
     case comment_reward_operation
     case liquidity_reward_operation
     case interest_operation
     case fill_vesting_withdraw_operation
     case fill_order_operation
     case shutdown_witness_operation
     case fill_transfer_from_savings_operation
     case hardfork_operation
     case comment_payout_update_operation
     */
    
    
    /// This method return request parameters from selected enum case.
    public func getFields() -> [Any] {
        /// Return array: [ operationName, operationCode, [ operationFieldKey: operationFieldValue ] ]
        switch self {
        case .vote(let voteOperation):
            return  [ "vote", 0,    [
                                        "voter":                voteOperation.voter,
                                        "author":               voteOperation.author,
                                        "permlink":             voteOperation.permlink,
                                        "weight":               voteOperation.weight
                                    ]
                    ]
            
        case .comment(let commentOperation):
            return  [ "comment", 1, [
                                        "parent_author":        commentOperation.parentAuthor,
                                        "parent_permlink":      commentOperation.parentPermlink,
                                        "author":               commentOperation.author,
                                        "permlink":             commentOperation.permlink,
                                        "title":                commentOperation.title,
                                        "body":                 commentOperation.body,
                                        "json_metadata":        commentOperation.jsonMetadata
                                    ]
                    ]
            
        case .commentOptions(let commentOptionsOperation):
            return  [ "comment_options", 2, [
                                                "author":                       commentOptionsOperation.author,
                                                "permlink":                     commentOptionsOperation.permlink,
                                                "max_accepted_payout":          commentOptionsOperation.max_accepted_payout,
                                                "percent_steem_dollars":        commentOptionsOperation.percent_steem_dollars,
                                                "allow_votes":                  commentOptionsOperation.allow_votes,
                                                "allow_curation_rewards":       commentOptionsOperation.allow_curation_rewards,
                                                "extensions":                   commentOptionsOperation.extensions
                                            ]
                    ]
            
        case .createPost(let comment, let commentOptions, let vote):
            return  [ "operations", 3,  [
                                            comment, commentOptions, vote
                                        ]
                    ]
        }
    }
    
    
    /// This method return sorted array of field key names
    public static func getFieldNames(byTypeID typeID: Int) -> [String] {
        /// Return array: [ operationFieldKey ]
        switch typeID {
        case 0:
            return [ "voter", "author", "permlink", "weight" ]
            
        case 1:
            return [ "parent_author", "parent_permlink", "author", "permlink", "title", "body", "json_metadata" ]
            
        default:
            break
        }
        
        return []
    }
}
