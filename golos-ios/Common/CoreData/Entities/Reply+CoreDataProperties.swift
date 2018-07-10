//
//  Reply+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension Reply {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reply> {
        return NSFetchRequest<Reply>(entityName: "Reply")
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

}
