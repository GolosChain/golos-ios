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

/// Type of request parameters
typealias OperationRequestParameters = (operationAPIType: OperationAPIType, paramsFirst: [String], paramsSecond: [Encodable])

/// API POST operations
public indirect enum OperationAPIType {
    /// In Work
    // API: POST
    case createPost(operations: [Encodable])
    case vote(fields: RequestParameterAPI.Vote)
    case voteAuth(fields: RequestParameterAPI.Vote)
    case comment(fields: RequestParameterAPI.Comment)
    case subscribe(fields: RequestParameterAPI.Subscription)
    case commentOptions(fields: RequestParameterAPI.CommentOptions)
    
    
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
    func introduced() -> OperationRequestParameters {
        switch self {
        case .vote(let voteValue):                          return  (operationAPIType:      self,
                                                                     paramsFirst:           ["network_broadcast_api", "broadcast_transaction"],
                                                                     paramsSecond:          [voteValue])
            
        case .voteAuth(let voteValue):                      return  (operationAPIType:      self,
                                                                     paramsFirst:           [],
                                                                     paramsSecond:          [voteValue])
            
        case .comment(let commentValue):                    return  (operationAPIType:      self,
                                                                     paramsFirst:           ["network_broadcast_api", "broadcast_transaction"],
                                                                     paramsSecond:          [commentValue])
            
        case .commentOptions(let commentOptionsValue):      return  (operationAPIType:      self,
                                                                     paramsFirst:           ["network_broadcast_api", "broadcast_transaction"],
                                                                     paramsSecond:          [commentOptionsValue])
            
        case .createPost(let operations):                   return  (operationAPIType:      self,
                                                                     paramsFirst:           ["network_broadcast_api", "broadcast_transaction"],
                                                                     paramsSecond:          operations)
            
        case .subscribe(let subscriptionValue):             return  (operationAPIType:      self,
                                                                     paramsFirst:           ["network_broadcast_api", "broadcast_transaction"],
                                                                     paramsSecond:          [subscriptionValue])
        }
    }
}
