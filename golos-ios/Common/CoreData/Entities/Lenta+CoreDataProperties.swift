//
//  Lenta+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 12.09.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension Lenta: PostCellSupport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lenta> {
        return NSFetchRequest<Lenta>(entityName: "Lenta")
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
    @NSManaged public var userNickName: String
    @NSManaged public var pendingPayoutValue: Float
    @NSManaged public var children: Int64

    @NSManaged public var likeCount: Int64
    @NSManaged public var currentUserLiked: Bool
    
    @NSManaged public var dislikeCount: Int64
    @NSManaged public var currentUserDisliked: Bool
    
    @NSManaged public var commentsCount: Int64
    @NSManaged public var currentUserCommented: Bool

    @NSManaged public var tags: [String]?
    @NSManaged public var rebloggedBy: [String]?
    
    @NSManaged public var reblogBody: String?
    @NSManaged public var reblogTitle: String?
    @NSManaged public var authorReblog: String?
    @NSManaged public var rebloggedFirstOn: String?
    @NSManaged public var jsonMetadataReblog: String?
    
    @NSManaged public var active: Date
    @NSManaged public var created: Date
    @NSManaged public var lastUpdate: Date
    @NSManaged public var lastPayout: Date
    
}
