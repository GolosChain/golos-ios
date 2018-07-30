//
//  SettingNotification+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 30.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(SettingNotification)
public class SettingNotification: NSManagedObject {
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let model       =   responseAPI as! ResponseAPIPost
        var entity      =   CoreDataManager.instance.readEntity(withName:                   "SettingNotification",
                                                                andPredicateParameters:     NSPredicate.init(format: "name == \(model.author)")) as? SettingNotification
        
        // Get SettingNotification entity
        if entity == nil {
            entity      =   CoreDataManager.instance.createEntity("SettingNotification") as? SettingNotification
        }
        
        // Update entity
        entity!.name    =   model.author
        entity!.isOn    =   model.allow_votes
    }
}
