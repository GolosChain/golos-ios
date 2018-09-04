//
//  Lenta+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Lenta)
public class Lenta: NSManagedObject, CachedImageFrom {
    // MARK: - CachedImageFrom protocol implementation
    var fromItem: String = "lenta"

    
    // MARK: - Properties
    var userNameValue: String {
        set {
            self.userName = userNameValue
        }
        
        get {
            return self.userName
        }
    }


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
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Lenta",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Lenta
        
        // Get Lenta entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Lenta") as? Lenta

            if let entityIndex = try? CoreDataManager.instance.managedObjectContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Lenta")) {
                entity!.sortID  =   Int16(entityIndex)
            }
        }
        
        // Update entity
        entity!.userName    =   User.current!.name
        entity!.update(withModel: model)
    }
}
