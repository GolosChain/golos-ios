//
//  AppSettings+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 05.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var language: String
    @NSManaged public var userNickName: String
    @NSManaged public var isAppThemeDark: Bool
    @NSManaged public var startWithWelcomeScene: Bool
}
