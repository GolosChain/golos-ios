//
//  RequestParameterAPI.swift
//  GoloSwift
//
//  Created by msm72 on 01.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

public struct RequestParameterAPI {
    public struct User: Encodable {
        // MARK: - Properties
        public let names: [String]
        
        // MARK: - Initialization
        public init(names: [String]) {
            self.names  =   names
        }
    }
    
    public struct Discussion: Encodable {
        // MARK: - Properties
        public let limit: UInt
        public let truncate_body: UInt?
        public let selectTags: [String]?
        public let filterTags: [String]?
        public let select_authors: [String]?
        public let selectLanguages: [String]?
        public let filterLanguages: [String]?
        public let start_author: String?
        public let start_permlink: String?
        public let parentAuthor: String?
        public let parentPermlink: String?
        public let vote_limit: UInt?
        
        
        // MARK: - Initialization
        public init(limit: UInt, truncateBody: UInt? = 1024, selectTags: [String]? = nil, filterTags: [String]? = nil, selectAuthors: [String]? = nil, selectLanguages: [String]? = nil, filterLanguages: [String]? = nil, startAuthor: String? = nil, startPermlink: String? = nil, parentAuthor: String? = nil, parentPermlink: String? = nil, voteLimit: UInt? = 0) {
            self.limit              =   limit
            self.truncate_body      =   truncateBody
            self.selectTags         =   selectTags
            self.filterTags         =   filterTags
            self.select_authors     =   selectAuthors
            self.selectLanguages    =   selectLanguages
            self.filterLanguages    =   filterLanguages
            self.start_author       =   startAuthor
            self.start_permlink     =   startPermlink
            self.parentAuthor       =   parentAuthor
            self.parentPermlink     =   parentPermlink
            self.vote_limit         =   voteLimit
        }
    }
    
    public struct Comment: Encodable {
        // MARK: - Properties
        public let parentAuthor: String
        public var parentPermlink: String
        public let author: String
        public let title: String
        public var body: String {
            didSet {
                self.permlink = ""
            }
        }
        
        public let jsonMetadata: [CommentMetadata]

        public var permlink: String {
            set {
                if parentAuthor.isEmpty {
                    self.permlink   =   String(format: "%@-%@-%d", author, title.transliterationInLatin(), Int64(Date().timeIntervalSince1970))
                }
                
                else {
                    self.permlink   =   String(format: "re-%@-%@-%@-%d", parentAuthor, parentPermlink, author, Int64(Date().timeIntervalSince1970))
                }
            }
            
            get {
                return self.permlink
            }
        }

        // MARK: - Initialization
        public init(parentAuthor: String, parentPermlink: String, author: String, title: String, body: String, jsonMetadata: [CommentMetadata]) {
            self.parentAuthor       =   parentAuthor
            self.parentPermlink     =   parentPermlink
            self.author             =   author
            self.title              =   title
            self.body               =   body
            self.jsonMetadata       =   jsonMetadata
        }
    }
    
    public struct CommentMetadata: Encodable {
        // MARK: - Properties
        public let tags: [String]
        public var app: String      =   "golos.io/0.1"
        public var format: String   =   "markdown"
        
        // MARK: - Initialization
        public init(tags: [String]) {
            self.tags               =   tags
        }
    }
    
    
    public struct CommentOptions: Encodable {
        // MARK: - Properties
        public let author: String
        public let permlink: String
        public let max_accepted_payout: String
        public let percent_steem_dollars: UInt
        public let allow_votes: Bool
        public let allow_curation_rewards: Bool
        public let extensions: [String]
        
        
        // MARK: - Initialization
        public init(author: String, permlink: String, maxAcceptedPayout: String, percentSteemDollars: UInt, allowVotes: Bool, allowCurationRewards: Bool, extensions: [String]) {
            self.author                 =   author
            self.permlink               =   permlink
            self.max_accepted_payout    =   maxAcceptedPayout
            self.percent_steem_dollars  =   percentSteemDollars
            self.allow_votes            =   allowVotes
            self.allow_curation_rewards =   allowCurationRewards
            self.extensions             =   extensions
        }
    }
    
    public struct Vote: Encodable {
        // MARK: - Properties
        public let voter: String
        public let author: String
        public let permlink: String
        public let weight: Int64

        
        // MARK: - Initialization
        public init(voter: String, author: String, permlink: String, weight: Int64) {
            self.voter                  =   voter
            self.author                 =   author
            self.permlink               =   permlink
            self.weight                 =   weight
        }
    }

}
