//
//  Reply+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Reply)
public class Reply: NSManagedObject {
    // MARK: - MetaDataSupport protocol implementation
    func set(tags: [String]?) {
        self.tags   =   tags
    }
    
    func set(coverImageURL: String?) {
        self.coverImageURL = coverImageURL
    }
    
    
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let replyModel      =   responseAPI as! ResponseAPIFeed
        var replyEntity     =   CoreDataManager.instance.readEntity(withName:                   "Reply",
                                                                    andPredicateParameters:     NSPredicate.init(format: "id == \(replyModel.id)")) as? Reply
        
        // Get Reply entity
        if replyEntity == nil {
            replyEntity     =   CoreDataManager.instance.createEntity("Reply") as? Reply
        }
        
        // Update entity
        replyEntity!.update(withModel: replyModel)
    }
}
