//
//  ResponseAPI.swift
//  Golos
//
//  Created by msm72 on 13.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct ResponseAPIResultError: Decodable {
    // MARK: - Properties
    let error: ResponseAPIError
    let id: Int64
    let jsonrpc: String
}

struct ResponseAPIError: Decodable {
    // MARK: - Properties
    let code: Int64
    let message: String
}

struct ResponseAPIFeedResult: Decodable {
    // MARK: - Properties
    let id: Int64
    let jsonrpc: String
    let result: [ResponseAPIFeed]
}

struct ResponseAPIFeed: Decodable {
    // MARK: - Properties
    // swiftlint:disable identifier_name
    let abs_rshares: Conflicted
    let active: String
    let active_votes: [ResponseAPIActiveVote]

    let allow_curation_rewards: Bool
    let allow_replies: Bool
    let allow_votes: Bool
    let author: String
    let author_reputation: Conflicted
    let author_rewards: Int
//    beneficiaries =             ();       // ???
    let body: String
    let body_length: Int64
    let cashout_time: String                // "2018-04-20T10:19:54"
    let category: String
    let children: Int
    let children_abs_rshares: Conflicted
    let children_rshares2: String
    let created: String                     // "2018-04-13T10:19:54"
    let curator_payout_value: String
    let depth: Int
    let id: Int64
    let json_metadata: String?
    let last_payout: String                 // "1970-01-01T00:00:00"
    let last_update: String                 // "2018-04-13T11:03:12"
    let max_accepted_payout: String
    let max_cashout_time: String            // "1969-12-31T23:59:59"
    let mode: String
    let net_rshares: Conflicted
    let net_votes: Int64
    let parent_author: String?
    let parent_permlink: String
    let pending_payout_value: String
    let percent_steem_dollars: Int64
    let permlink: String
    let promoted: String
//    "reblogged_by" =             ();      // ???
//    replies =             ();             // ???
    let reward_weight: Int64
    let root_comment: Int64
    let root_title: String
    let title: String
    let total_payout_value: String
    let total_pending_payout_value: String
    let total_vote_weight: Conflicted
    let url: String
    let vote_rshares: Conflicted
    // swiftlint:enable identifier_name
}

struct ResponseAPIActiveVote: Decodable {
    // MARK: - Properties
    let percent: Int16
    let reputation: Conflicted
    let rshares: Conflicted
    let time: String
    let voter: String
    let weight: Conflicted
}

/// [Multiple types](https://stackoverflow.com/questions/46759044/swift-structures-handling-multiple-types-for-a-single-property)
struct Conflicted: Codable {
    let stringValue: String?

    // Where we determine what type the value is
    init(from decoder: Decoder) throws {
        let container       =   try decoder.singleValueContainer()

        do {
            stringValue     =   try container.decode(String.self)
        } catch {
            // Check for an integer
            let intValue    =   try container.decode(Int64.self)
            stringValue     =   "\(intValue)"
        }
    }

    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    func encode(to encoder: Encoder) throws {
        var container       =   encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}


struct ResponseAPIUserResult: Decodable {
    // MARK: - Properties
    let id: Int64
    let jsonrpc: String
    let result: [ResponseAPIUser]
}

struct ResponseAPIUser: Decodable {
    // MARK: - Properties
    // swiftlint:disable identifier_name
//    let active: =     {
//    "account_auths" =         (
//    );
//    "key_auths" =         (
//    (
//    GLS5z37eHubGDFEYT1qizCa5CcTjdUkvXKvKWb4i926FVy3r4AaCx,
//    1
//    )
//    );
//
//    "weight_threshold" = 1;
//    };

    let active_challenged: Bool
    let average_bandwidth: Conflicted
    let average_market_bandwidth: Conflicted
    let balance: String
//    "blog_category" =     {
//    };
    
    let can_vote: Bool
    let comment_count: Int64
    let created: String                                 // "2017-10-09T21:10:21"
    let curation_rewards: Int64
    let delegated_vesting_shares: String
//    "guest_bloggers" =     (
//    );
    let id: Int64
    let json_metadata: String?
    let last_account_recovery: String                   // "1970-01-01T00:00:00"
    let last_account_update: String                     // "2017-10-09T21:15:21"
    let last_active_proved: String                      // "1970-01-01T00:00:00"
    let last_bandwidth_update: String                   // "2018-04-18T08:25:03"
    let last_market_bandwidth_update: String            // "2018-04-17T23:14:24"
    let last_owner_proved: String                       // "1970-01-01T00:00:00"
    let last_owner_update: String                       // "2017-10-09T21:15:21"
    let last_post: String                               // "2018-04-17T14:21:51"
    let last_root_post: String                          // "2018-04-17T14:16:42"
    let last_vote_time: String                          // "2018-04-18T08:25:03"
    let lifetime_bandwidth: String
    let lifetime_vote_count: Int64
    let market_history: [String]?
    let memo_key: String
    let mined: Bool
    let name: String
    let new_average_bandwidth: String
    let new_average_market_bandwidth: Conflicted
    let next_vesting_withdrawal: String                 // "1969-12-31T23:59:59"
    let other_history: [String]?
    
//    owner =     {
//    "account_auths" =         (
//    );
//    "key_auths" =         (
//    (
//    GLS8fFA4S7MaXms5VDcpKa4aNQLMCAUSoi9n7WSGR9Hu7PTeKhGDT,
//    1
//    )
//    );
//    "weight_threshold" = 1;
//    };
    
    let owner_challenged: Bool
    let post_bandwidth: Int64
    let post_count: Int64
    let post_history: [String]?
    
//    posting =     {
//    "account_auths" =         (
//    );
//    "key_auths" =         (
//    (
//    GLS57N6Lsbb1qxenBcLsbFKi5KSTHkhWQhiKYGw3We2E1bKwvrwUu,
//    1
//    )
//    );
//    "weight_threshold" = 1;
//    };
    
    let posting_rewards: Int64
    let proxied_vsf_votes: [Conflicted]
    let proxy: String?
    let received_vesting_shares: String
    let recovery_account: String
    let reputation: Conflicted
    let reset_account: String?
    let savings_balance: String
    let savings_sbd_balance: String
    let savings_sbd_last_interest_payment: String           // "1970-01-01T00:00:00"
    let savings_sbd_seconds: String
    let savings_sbd_seconds_last_update: String             // "1970-01-01T00:00:00"
    let savings_withdraw_requests: Int64
    let sbd_balance: String
    let sbd_last_interest_payment: String                   // "2018-04-08T09:06:42"
    let sbd_seconds: String
    let sbd_seconds_last_update: String                     // "2018-04-18T07:57:33"
    let tags_usage: [String]?
    let to_withdraw: Conflicted
    let transfer_history: [String]?
    let vesting_balance: String
    let vesting_shares: String
    let vesting_withdraw_rate: String
    let vote_history: [Int64]?
    let voting_power: Int64
    let withdraw_routes: Int64
    let withdrawn: Conflicted
    let witness_votes: [String]?
    let witnesses_voted_for: Int64
    // swiftlint:enable identifier_name
}

