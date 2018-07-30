//
//  SettingNotification+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 30.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension SettingNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingNotification> {
        return NSFetchRequest<SettingNotification>(entityName: "SettingNotification")
    }

    @NSManaged public var name: String?
    @NSManaged public var isOn: Bool

}
