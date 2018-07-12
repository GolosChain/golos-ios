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
    @NSManaged public var memoKey: String?
    @NSManaged public var postsAmount: Int64
    @NSManaged public var isAuthorized: Bool
    @NSManaged public var vestingShares: String
    @NSManaged public var json_metadata: String?
    @NSManaged public var reputation: String
    @NSManaged public var profileImageURL: String?
    @NSManaged public var coverImageURL: String?
    @NSManaged public var gender: String?
    @NSManaged public var selectTags: [String]?
    @NSManaged public var canVote: Bool
    @NSManaged public var created: String
    @NSManaged public var commentCount: Int64

    @NSManaged public var owner: UserSecretOwnerKey?
    @NSManaged public var active: UserSecretActiveKey?
    @NSManaged public var posting: UserSecretPostingKey?

}
