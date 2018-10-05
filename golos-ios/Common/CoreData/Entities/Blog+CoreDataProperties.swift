//
//  Blog+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 20.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import Foundation

extension Blog: PostCellSupport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Blog> {
        return NSFetchRequest<Blog>(entityName: "Blog")
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
    @NSManaged public var url: String?
    @NSManaged public var coverImageURL: String?
    @NSManaged public var userName: String
    @NSManaged public var pendingPayoutValue: Float
    @NSManaged public var children: Int64

    @NSManaged public var netVotes: Int64
    @NSManaged public var currentUserVoted: Bool
    
    @NSManaged public var commentsCount: Int64
    @NSManaged public var currentUserCommented: Bool    

    @NSManaged public var currentUserFlaunted: Bool
    
    @NSManaged public var tags: [String]?
    @NSManaged public var rebloggedBy: [String]?
    
    @NSManaged public var active: Date
    @NSManaged public var created: Date
    @NSManaged public var lastUpdate: Date
    @NSManaged public var lastPayout: Date
    
}
