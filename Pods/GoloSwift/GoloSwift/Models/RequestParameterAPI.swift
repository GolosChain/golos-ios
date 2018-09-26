//
//  RequestParameterAPI.swift
//  GoloSwift
//
//  Created by msm72 on 01.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol RequestParameterAPIOperationPropertiesSupport {
    var code: Int? { get set }
    var name: String? { get set }
    func getProperties() -> [String: Any]
    func getPropertiesNames() -> [String]
}


public struct RequestParameterAPI {
    static func decodeToString(model: RequestParameterAPIOperationPropertiesSupport) -> String? {
        // Data encoder
        let jsonEncoder = JSONEncoder()
        var jsonData = Data()
        
        // Add operation name
        var result = String(format: "\"%@\",{", model.name ?? "")
        Logger.log(message: "\nResult + operationName:\n\t\(result)", event: .debug)
        
        let properties = model.getProperties()
        let propertiesNames = model.getPropertiesNames()
        
        do {
            for (_, propertyName) in propertiesNames.enumerated() {
                let propertyValue = properties.first(where: { $0.key == propertyName })!.value
                
                // Casting Types
                if propertyValue is String {
                    jsonData = try jsonEncoder.encode(["\(propertyName)": "\(propertyValue)"])
                }
                    
                else if propertyValue is Int64 {
                    jsonData = try jsonEncoder.encode(["\(propertyName)": propertyValue as! Int64])
                }
                
                result += "\(String(data: jsonData, encoding: .utf8)!)"
                Logger.log(message: "\nResult + \"\(propertyName)\":\n\t\(result)", event: .debug)
            }
            
            return  result
                        .replacingOccurrences(of: "{{", with: "{")
                        .replacingOccurrences(of: "}{", with: ",")
                        .replacingOccurrences(of: "}\"}", with: "}\"")
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return nil
        }
    }
    
    public struct User: Encodable {
        // MARK: - Properties
        public let names: [String]
        
        // MARK: - Initialization
        public init(names: [String]) {
            self.names = names
        }
    }
    
    public struct Content: Encodable {
        // MARK: - Properties
        public let author: String
        public let permlink: String
        public let active_votes: UInt?
        
        // MARK: - Initialization
        public init(author: String, permlink: String, active_votes: UInt? = 0) {
            self.author         =   author
            self.permlink       =   permlink
            self.active_votes   =   active_votes
        }
        
        
        // MARK: - Custom Functions
        public func convertToString() -> String {
            return String(format: "\"%@\",\"%@\",%i", self.author, self.permlink, self.active_votes!)
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
        public let vote_limit: Int?
        
        
        // MARK: - Initialization
        public init(limit: UInt, truncateBody: UInt? = 1024, selectTags: [String]? = nil, filterTags: [String]? = nil, selectAuthors: [String]? = nil, selectLanguages: [String]? = nil, filterLanguages: [String]? = nil, startAuthor: String? = nil, startPermlink: String? = nil, parentAuthor: String? = nil, parentPermlink: String? = nil, voteLimit: Int? = 0) {
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
    
    public struct Comment: Encodable, RequestParameterAPIOperationPropertiesSupport {
        // MARK: - Properties
        public let parentAuthor: String
        public var parentPermlink: String
        public let author: String
        public let title: String
        public var body: String
        public let jsonMetadata: String
        public var permlink: String
        public let needTiming: Bool
        
        
        // MARK: - Initialization
        public init(parentAuthor: String, parentPermlink: String, author: String, title: String, body: String, jsonMetadata: String, needTiming: Bool, attachments: [Attachment]? = nil) {
            self.parentAuthor   =   parentAuthor
            self.parentPermlink =   parentPermlink
            self.author         =   author
            self.title          =   title
            self.jsonMetadata   =   jsonMetadata
            self.needTiming     =   needTiming
            
            let permlinkTemp    =   (parentAuthor.isEmpty ? String(format: "%@", title.transliteration()) :
                                                            String(format: "re-%@-%@-%@", parentAuthor, parentPermlink, author))
                                        .replacingOccurrences(of: " ", with: "-")
                                        .replacingOccurrences(of: ".", with: "-")
                                        .lowercased()
            
            self.permlink   =   needTiming ? (permlinkTemp + "-\(Int64(Date().timeIntervalSince1970))") : permlinkTemp
            
            if let parameters = attachments {
                self.body   =   parameters.compactMap({ $0.markdownValue ?? ""}).joined(separator: " ")
            }
                
            else {
                self.body   =   body
            }
        }
        
        
        // MARK: - RequestParameterAPIOperationPropertiesSupport protocol implementation
        // https://github.com/GolosChain/golos-js/blob/master/src/auth/serializer/src/ChainTypes.js
        var code: Int?     =   1
        var name: String?  =   "comment"
        
        public func getProperties() -> [String: Any] {
            return  [
                        "parent_author":    self.parentAuthor,
                        "parent_permlink":  self.parentPermlink,
                        "author":           self.author,
                        "permlink":         self.permlink,
                        "title":            self.title,
                        "body":             self.body,
                        "json_metadata":    self.jsonMetadata
                    ]
        }
        
        func getPropertiesNames() -> [String] {
            return [ "parent_author", "parent_permlink", "author", "permlink", "title", "body", "json_metadata" ]
        }
    }
    
    
    public struct CommentOptions: Encodable, RequestParameterAPIOperationPropertiesSupport {
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
        
        
        // MARK: - OperationTypePropertiesSupport protocol implementation
        // https://github.com/GolosChain/golos-js/blob/master/src/auth/serializer/src/ChainTypes.js
        var code: Int?     =   19
        var name: String?  =   "comment_options"
        
        public func getProperties() -> [String: Any] {
            return  [
                        "author":                   self.author,
                        "permlink":                 self.permlink,
                        "max_accepted_payout":      self.max_accepted_payout,
                        "percent_steem_dollars":    self.percent_steem_dollars,
                        "allow_votes":              self.allow_votes,
                        "allow_curation_rewards":   self.allow_curation_rewards,
                        "extensions":               self.extensions
                    ]
        }
        
        func getPropertiesNames() -> [String] {
            return [ "author", "permlink", "max_accepted_payout", "percent_steem_dollars", "allow_votes", "allow_curation_rewards", "extensions" ]
        }
    }
    
    public struct Vote: Encodable, RequestParameterAPIOperationPropertiesSupport {
        // MARK: - Properties
        public let voter: String
        public let author: String
        public let permlink: String
        public let weight: Int64
        
        
        // MARK: - Initialization
        public init(voter: String, author: String, permlink: String, weight: Int64) {
            self.voter      =   voter
            self.author     =   author
            self.permlink   =   permlink
            self.weight     =   weight
        }
        
        
        // MARK: - OperationTypePropertiesSupport protocol implementation
        // https://github.com/GolosChain/golos-js/blob/master/src/auth/serializer/src/ChainTypes.js
        var code: Int?     =   0
        var name: String?  =   "vote"
        
        public func getProperties() -> [String: Any] {
            return  [
                        "voter":        self.voter,
                        "author":       self.author,
                        "permlink":     self.permlink,
                        "weight":       self.weight
                    ]
        }
        
        func getPropertiesNames() -> [String] {
            return [ "voter", "author", "permlink", "weight" ]
        }
    }
}
