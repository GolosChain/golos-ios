//
//  Popular+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 17.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Popular)
public class Popular: NSManagedObject, CachedImageFrom {
    // MARK: - CachedImageFrom protocol implementation
    var fromItem: String = "popular"

    
    // MARK: - MetaDataSupport protocol implementation
    func set(tags: [String]?) {
        self.tags   =   tags
    }
    
    func set(coverImageURL: String?) {
        self.coverImageURL = coverImageURL
    }
    
    
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let model   =   responseAPI as! ResponseAPIPost
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Popular",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Popular
        
        // Get Popular entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Popular") as? Popular
            
            if let entityIndex = try? CoreDataManager.instance.managedObjectContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Popular")) {
                entity!.sortID  =   Int16(entityIndex)
            }
        }
        
        // Update entity
        entity!.update(withModel: model)
    }
}
