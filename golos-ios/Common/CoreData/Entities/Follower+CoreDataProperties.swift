//
//  Follower+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 10/31/18.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension Follower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Follower> {
        return NSFetchRequest<Follower>(entityName: "Follower")
    }

    @NSManaged public var follower: String
    @NSManaged public var following: String
    @NSManaged public var paginationPage: Int16
    
    @NSManaged public var what: [String]?

}
