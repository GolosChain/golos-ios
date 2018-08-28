//
//  ImageCached+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 23.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ImageCached)
public class ImageCached: NSManagedObject {
    // MARK: - Class Functions
    class func updateEntity(fromItem: String, byDate created: Date, andKey cachedKey: String) {
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "ImageCached",
                                                            andPredicateParameters:     NSPredicate.init(format: "cachedKey == %@", cachedKey)) as? ImageCached
        
        // Get ImageCached entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("ImageCached") as? ImageCached
        }
        
        // Update entity
        entity!.created     =   created as NSDate
        entity!.cachedKey   =   cachedKey
        entity!.fromItem    =   fromItem

        entity!.save()
    }
}
