//
//  New+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 17.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(New)
public class New: NSManagedObject {
    // MARK: - MetaDataSupport protocol implementation
    func set(tags: [String]?) {
        self.tags   =   tags
    }
    
    func set(coverImageURL: String?) {
        self.coverImageURL = coverImageURL
    }
    
    
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let model   =   responseAPI as! ResponseAPIFeed
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "New",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? New
        
        // Get New entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("New") as? New
        }
        
        // Update entity
        entity!.update(withModel: model)
    }
}
