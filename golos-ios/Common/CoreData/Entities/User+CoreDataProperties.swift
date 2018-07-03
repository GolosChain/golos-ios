//
//  User+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var post_count: Int64
    @NSManaged public var json_metadata: String?
    @NSManaged public var memo: UserSecretKey?
    @NSManaged public var owner: UserSecretKey?
    @NSManaged public var active: UserSecretKey?
    @NSManaged public var posting: UserSecretKey?

}
