//
//  Voter+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 10/26/18.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension Voter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Voter> {
        return NSFetchRequest<Voter>(entityName: "Voter")
    }

    @NSManaged public var reputation: String
    @NSManaged public var postID: Int64
    @NSManaged public var voter: String
    @NSManaged public var weight: String
    @NSManaged public var rshares: String
    @NSManaged public var percent: Int64
    @NSManaged public var time: String

}
