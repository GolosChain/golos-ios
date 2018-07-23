//
//  Blog+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 20.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Blog)
public class Blog: NSManagedObject  {
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
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Blog",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Blog
        
        // Get Blog entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Blog") as? Blog
        }
        
        // Update entity
        entity!.update(withModel: model)
    }
}
