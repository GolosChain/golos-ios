//
//  BlogEntry+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 11/8/18.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(BlogEntry)
public class BlogEntry: NSManagedObject {
    // MARK: - Class Functions
    class func loadEntries(byBlog blog: String) -> [BlogEntry]? {
        return CoreDataManager.instance.readEntities(withName:                  "BlogEntry",
                                                     withPredicateParameters:   NSPredicate(format: "blog == %@", blog),
                                                     andSortDescriptor:         nil) as? [BlogEntry]
    }
    
    class func updateEntity(fromResponseAPIResult responseAPIResult: [Decodable]) {
        for responseAPIEntry in responseAPIResult {
            let model   =   responseAPIEntry as! ResponseAPIEntry
            
            var entity  =   CoreDataManager.instance.readEntity(withName:                   "BlogEntry",
                                                                andPredicateParameters:     NSPredicate.init(format: "id == \(model.entry_id)")) as? BlogEntry
            
            // Get BlogEntry entity
            if entity == nil {
                entity  =   CoreDataManager.instance.createEntity("BlogEntry") as? BlogEntry
            }
            
            // Update entity
            entity!.id                  =   model.entry_id
            entity!.blog                =   model.blog
            entity!.author              =   model.author
            entity!.permlink            =   model.permlink
            entity!.reblogOn            =   model.reblog_on
            entity!.reblogBody          =   model.reblog_body
            entity!.reblogTitle         =   model.reblog_title
            entity!.reblogMetadataJSON  =   model.reblog_json_metadata
            
            entity!.save()
        }
    }
}
