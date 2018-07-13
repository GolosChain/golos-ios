//
//  Post+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 09.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int64
    @NSManaged public var author: String
    @NSManaged public var parentAuthor: String?
    @NSManaged public var created: Date
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
    @NSManaged public var tags: [String]?
    @NSManaged public var coverImageURL: String?

}
