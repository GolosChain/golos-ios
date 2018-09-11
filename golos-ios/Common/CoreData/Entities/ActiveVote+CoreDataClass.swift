//
//  ActiveVote+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 23.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(ActiveVote)
public class ActiveVote: NSManagedObject {
    // MARK: - Class Functions
    class func updateEntities(fromResponseAPI responseAPI: [Decodable], withParentID codeID: Int64) -> [ActiveVote]? {
        let models  =   responseAPI as! [ResponseAPIActiveVote]
        
        for model in models {
            var entity  =   CoreDataManager.instance.readEntity(withName:                   "ActiveVote",
                                                                andPredicateParameters:     NSPredicate.init(format: "id == \(codeID) AND voter == %@", model.voter)) as? ActiveVote
            
            // Get ActiveVote entity
            if entity == nil {
                entity  =   CoreDataManager.instance.createEntity("ActiveVote") as? ActiveVote
            }
            
            // Update entity
            entity!.id              =   codeID
            entity!.percent         =   model.percent
            entity!.rshares         =   model.rshares.stringValue


            // MARK: - In reserve
            /*
            entity!.reputation      =   model.reputation.stringValue
            entity!.time            =   model.time
            entity!.voter           =   model.voter
            entity!.weight          =   model.weight.stringValue
            */
            
            // Extension
            entity!.save()
        }
        
        return CoreDataManager.instance.readEntities(withName: "ActiveVote",
                                                     withPredicateParameters: NSPredicate.init(format: "id == \(codeID)"), andSortDescriptor: nil) as? [ActiveVote]
    }
}
