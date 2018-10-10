//
//  Comment+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 08.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Comment)
public class Comment: NSManagedObject, CachedImageFrom {
    var treeIndex: String = ""
    var treeLevel: Int = 0
    
    // MARK: - CachedImageFrom protocol implementation
    var fromItem: String = "comment"
    
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
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Comment",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Comment
        
        // Get Comment entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Comment") as? Comment
        }
        
        // Update entity
        entity!.update(withModel: model)
    }
}
