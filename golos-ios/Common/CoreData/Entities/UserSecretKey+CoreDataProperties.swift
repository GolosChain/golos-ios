//
//  UserSecretKey+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension UserSecretKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSecretKey> {
        return NSFetchRequest<UserSecretKey>(entityName: "UserSecretKey")
    }

    @NSManaged public var weight_threshold: Int64
    @NSManaged public var account_auths: [String]?
    @NSManaged public var key_auths: [[String]]?
    
    @NSManaged public var memo: User?
    @NSManaged public var owner: User?
    @NSManaged public var active: User?
    @NSManaged public var posting: User?

}
