//
//  ActiveVote+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 23.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import Foundation


extension ActiveVote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveVote> {
        return NSFetchRequest<ActiveVote>(entityName: "ActiveVote")
    }

    @NSManaged public var percent: Int64
    @NSManaged public var reputation: String?
    @NSManaged public var rshares: String?
    @NSManaged public var time: String?
    @NSManaged public var voter: String
    @NSManaged public var weight: String?
    @NSManaged public var postID: Int64
    
}
