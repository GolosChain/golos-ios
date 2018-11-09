//
//  BlogEntry+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 11/8/18.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension BlogEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlogEntry> {
        return NSFetchRequest<BlogEntry>(entityName: "BlogEntry")
    }

    @NSManaged public var id: Int64
    @NSManaged public var blog: String
    @NSManaged public var author: String
    @NSManaged public var permlink: String
    @NSManaged public var reblogOn: String
    @NSManaged public var reblogBody: String?
    @NSManaged public var reblogTitle: String?
    @NSManaged public var reblogMetadataJSON: String?

}
