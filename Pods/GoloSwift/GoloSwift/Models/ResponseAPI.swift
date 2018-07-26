//
//  ResponseAPI.swift
//  GoloSwift
//
//  Created by msm72 on 13.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

// MARK: -
public struct ResponseAPIResultError: Decodable {
    // MARK: - In work
    public let error: ResponseAPIError
    public let id: Int64
    public let jsonrpc: String
}

// MARK: -
public struct ResponseAPIError: Decodable {
    // MARK: - In work
    public let code: Int64
    public let message: String
}


// MARK: -
public struct ResponseAPIFeedResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: [ResponseAPIFeed]?
    public let error: ResponseAPIError?
}

// MARK: -
public struct ResponseAPIFeed: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let body: String
    public let title: String
    public let author: String
    public let category: String
    public let permlink: String
    public let allow_votes: Bool
    public let allow_replies: Bool
    public let json_metadata: String?
    public let active_votes: [ResponseAPIActiveVote]
    public let parent_permlink: String
    public let parent_author: String?
    public let url: String?
    public let author_reputation: Conflicted
    public let pending_payout_value: String
    public let total_payout_value: String
    
    // "2018-04-13T10:19:54"
    public let created: String
    
    
    // MARK: - In reserve
    /*
     public let abs_rshares: Conflicted
     public let active: String
     
     public let allow_curation_rewards: Bool
     public let author_rewards: Int
     //    beneficiaries =             ();       // ???
     public let body_length: Int64
     public let cashout_time: String                // "2018-04-20T10:19:54"
     public let children: Int
     public let children_abs_rshares: Conflicted
     public let children_rshares2: String
     public let curator_payout_value: String
     public let depth: Int
     public let last_payout: String                 // "1970-01-01T00:00:00"
     public let last_update: String                 // "2018-04-13T11:03:12"
     public let max_accepted_payout: String
     public let max_cashout_time: String            // "1969-12-31T23:59:59"
     public let mode: String
     public let net_rshares: Conflicted
     public let net_votes: Int64
     public let percent_steem_dollars: Int64
     public let promoted: String
     //    "reblogged_by" =             ();      // ???
     //    replies =             ();             // ???
     public let reward_weight: Int64
     public let root_comment: Int64
     public let root_title: String
     public let total_pending_payout_value: String
     public let total_vote_weight: Conflicted
     public let vote_rshares: Conflicted
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIActiveVote: Decodable {
    // MARK: - In work
    public let percent: Int16
    public let reputation: Conflicted
    public let rshares: Conflicted
    public let time: String
    public let voter: String
    public let weight: Conflicted
}


/// [Multiple types](https://stackoverflow.com/questions/46759044/swift-structures-handling-multiple-types-for-a-single-property)
public struct Conflicted: Codable {
    public let stringValue: String?
    
    // Where we determine what type the value is
    public init(from decoder: Decoder) throws {
        let container           =   try decoder.singleValueContainer()
        
        do {
            stringValue         =   try container.decode(String.self)
        } catch {
            do {
                stringValue     =   "\(try container.decode(Int64.self))"
            } catch {
                stringValue     =   ""
            }
        }
    }
    
    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    public func encode(to encoder: Encoder) throws {
        var container       =   encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}


// MARK: -
public struct ResponseAPIUserResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: [ResponseAPIUser]?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIUser: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let name: String
    public let post_count: Int64
    public let json_metadata: String?
    public let memo_key: String?
    public let owner: ResponseAPIUserSecretKey?
    public let active: ResponseAPIUserSecretKey?
    public let posting: ResponseAPIUserSecretKey?
    public let vesting_shares: String
    public let reputation: Conflicted
    public let can_vote: Bool
    public let comment_count: Int64
    
    // "2017-10-09T21:10:21"
    public let created: String
    
    
    // MARK: - In reserve
    /*
     public let active_challenged: Bool
     public let average_bandwidth: Conflicted
     public let average_market_bandwidth: Conflicted
     public let balance: String
     //    "blog_category" =     {
     //    };
     
     public let curation_rewards: Int64
     public let delegated_vesting_shares: String
     //    "guest_bloggers" =     (
     //    );
     public let last_account_recovery: String                   // "1970-01-01T00:00:00"
     public let last_account_update: String                     // "2017-10-09T21:15:21"
     public let last_active_proved: String                      // "1970-01-01T00:00:00"
     public let last_bandwidth_update: String                   // "2018-04-18T08:25:03"
     public let last_market_bandwidth_update: String            // "2018-04-17T23:14:24"
     public let last_owner_proved: String                       // "1970-01-01T00:00:00"
     public let last_owner_update: String                       // "2017-10-09T21:15:21"
     public let last_post: String                               // "2018-04-17T14:21:51"
     public let last_root_post: String                          // "2018-04-17T14:16:42"
     public let last_vote_time: String                          // "2018-04-18T08:25:03"
     public let lifetime_bandwidth: String
     public let lifetime_vote_count: Int64
     public let market_history: [String]?
     public let mined: Bool
     public let new_average_bandwidth: String
     public let new_average_market_bandwidth: Conflicted
     public let next_vesting_withdrawal: String                 // "1969-12-31T23:59:59"
     public let other_history: [String]?
     
     public let owner_challenged: Bool
     public let post_bandwidth: Int64
     public let post_history: [String]?
     
     public let posting_rewards: Int64
     public let proxied_vsf_votes: [Conflicted]
     public let proxy: String?
     public let received_vesting_shares: String
     public let recovery_account: String
     public let reset_account: String?
     public let savings_balance: String
     public let savings_sbd_balance: String
     public let savings_sbd_last_interest_payment: String           // "1970-01-01T00:00:00"
     public let savings_sbd_seconds: String
     public let savings_sbd_seconds_last_update: String             // "1970-01-01T00:00:00"
     public let savings_withdraw_requests: Int64
     public let sbd_balance: String
     public let sbd_last_interest_payment: String                   // "2018-04-08T09:06:42"
     public let sbd_seconds: String
     public let sbd_seconds_last_update: String                     // "2018-04-18T07:57:33"
     public let tags_usage: [String]?
     public let to_withdraw: Conflicted
     public let transfer_history: [String]?
     public let vesting_balance: String
     public let vesting_withdraw_rate: String
     public let vote_history: [Int64]?
     public let voting_power: Int64
     public let withdraw_routes: Int64
     public let withdrawn: Conflicted
     public let witness_votes: [String]?
     public let witnesses_voted_for: Int64
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIUserSecretKey: Decodable {
    // MARK: - In work
    public let account_auths: [Conflicted]
    public let weight_threshold: Int64?
    public let key_auths: [[Conflicted]]
}


// MARK: -
public struct ResponseAPIDynamicGlobalPropertiesResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: ResponseAPIDynamicGlobalProperty?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIDynamicGlobalProperty: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let time: String                            // "2018-04-20T19:01:12"
    public let head_block_id: String
    public let head_block_number: Int64
    
    
    // MARK: - In reserve
    /*
     public let current_witness: String
     public let total_pow: Int64
     public let num_pow_witnesses: Int64
     public let virtual_supply: String
     public let current_supply: String
     public let confidential_supply: String
     public let current_sbd_supply: String
     public let confidential_sbd_supply: String
     public let total_vesting_fund_steem: String
     public let total_vesting_shares: String
     public let total_reward_fund_steem: String
     public let total_reward_shares2: String
     public let sbd_interest_rate: Int64
     public let sbd_print_rate: Int64
     public let average_block_size: Int64
     public let maximum_block_size: Int64
     public let current_aslot: Int64
     public let recent_slots_filled: String
     public let participation_count: Int64
     public let last_irreversible_block_num: Int64
     public let max_virtual_bandwidth: String
     public let current_reserve_ratio: Int64
     public let vote_regeneration_per_day: Int64
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIVerifyAuthorityResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: Bool?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIBlockchainPostResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: Bool?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIAllContentRepliesResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: [ResponseAPIAllContentReply]?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIAllContentReply: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let id: Int64
    public let author: String
    public let permlink: String
    public let category: String
    public let parent_author: String
    public let parent_permlink: String
    public let title: String
    public let body: String
    public let json_metadata: String
    
    
    // MARK: - In reserve
    /*
     public let last_update: String
     public let created: String
     public let active: String
     public let last_payout: String
     public let depth: Int
     public let children: Int
     public let children_rshares2: String
     public let net_rshares: Int
     public let abs_rshares: Int
     public let vote_rshares: Int
     public let children_abs_rshares: Int
     public let cashout_time: String
     public let max_cashout_time: String
     public let total_vote_weight: Int
     public let reward_weight: Int
     public let total_payout_value: String
     public let curator_payout_value: String
     public let author_rewards: Int
     public let net_votes: Int
     public let mode: String
     public let root_comment: Int64
     public let max_accepted_payout: String
     public let percent_steem_dollars: Int64
     public let allow_replies: Bool
     public let allow_votes: Bool
     public let allow_curation_rewards: Bool
     public let beneficiaries: [String]?
     public let url: String
     public let root_title: String
     public let pending_payout_value: String
     public let total_pending_payout_value: String
     public let active_votes: [String]?
     public let replies: [String]?
     public let author_reputation: String
     public let promoted: String
     public let body_length: Int
     public let reblogged_by: [String]?
     */
    // swiftlint:enable identifier_name
}


// MARK: -
public struct ResponseAPIUserFollowCountsResult: Decodable {
    // MARK: - In work
    public let id: Int64
    public let jsonrpc: String
    public let result: ResponseAPIUserFollowCounts?
    public let error: ResponseAPIError?
}


// MARK: -
public struct ResponseAPIUserFollowCounts: Decodable {
    // MARK: - In work
    // swiftlint:disable identifier_name
    public let account: String
    public let follower_count: Int16
    public let following_count: Int16
    public let limit: Int64
}
