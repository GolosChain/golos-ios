//
//  Promo+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 17.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Promo)
public class Promo: NSManagedObject {
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
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Promo",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Promo
        
        // Get Promo entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Promo") as? Promo
        }
        
        // Update entity
        entity!.update(withModel: model)
    }
}
