//
//  UserSecretMemoKey+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension UserSecretMemosKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSecretMemosKey> {
        return NSFetchRequest<UserSecretMemosKey>(entityName: "UserSecretMemosKey")
    }

    @NSManaged public var userID: Int64
    @NSManaged public var weight_threshold: Int64
    @NSManaged public var account_auths: [String]?
    @NSManaged public var key_auths: [[String]]?

    @NSManaged public var memo: User?

}
