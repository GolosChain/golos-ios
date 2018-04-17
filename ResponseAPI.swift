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

struct ResponseAPIResult: Decodable {
    // MARK: - Properties
    let id: Int64?
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
