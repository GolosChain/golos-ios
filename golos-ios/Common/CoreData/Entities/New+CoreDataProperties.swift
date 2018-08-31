//
//  New+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 17.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import Foundation

extension New: PostCellSupport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<New> {
        return NSFetchRequest<New>(entityName: "New")
    }

    @NSManaged public var id: Int64
    @NSManaged public var author: String
    @NSManaged public var authorReputation: String
    @NSManaged public var parentAuthor: String?
    @NSManaged public var category: String
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var permlink: String
    @NSManaged public var parentPermlink: String?
    @NSManaged public var allowVotes: Bool
    @NSManaged public var allowReplies: Bool
    @NSManaged public var jsonMetadata: String?
    @NSManaged public var activeVotesCount: Int16
    @NSManaged public var url: String?
    @NSManaged public var coverImageURL: String?
    @NSManaged public var pendingPayoutValue: Float
    @NSManaged public var children: Int16

    @NSManaged public var tags: [String]?
    @NSManaged public var rebloggedBy: [String]?
    
    @NSManaged public var active: Date
    @NSManaged public var created: Date
    @NSManaged public var lastUpdate: Date
    @NSManaged public var lastPayout: Date
    
    @NSManaged public var activeVotes: NSSet?
    
}

// MARK: Generated accessors for activeVotes
extension New {
    
    @objc(addActiveVotesObject:)
    @NSManaged public func addToActiveVotes(_ value: ActiveVote)
    
    @objc(removeActiveVotesObject:)
    @NSManaged public func removeFromActiveVotes(_ value: ActiveVote)
    
    @objc(addActiveVotes:)
    @NSManaged public func addToActiveVotes(_ values: NSSet)
    
    @objc(removeActiveVotes:)
    @NSManaged public func removeFromActiveVotes(_ values: NSSet)
    
}
