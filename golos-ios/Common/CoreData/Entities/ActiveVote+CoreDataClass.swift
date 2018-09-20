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
    class func loadActiveVotes(byPostID postID: Int64) -> [ActiveVote]? {
        return CoreDataManager.instance.readEntities(withName:                  "ActiveVote",
                                                     withPredicateParameters:   NSPredicate(format: "postID == \(postID)"),
                                                     andSortDescriptor:         nil) as? [ActiveVote]
    }
    
    class func isUserVoted(currentPost postID: Int64) -> Bool {
        return CoreDataManager.instance.readEntities(withName:                  "ActiveVote",
                                                     withPredicateParameters:   NSPredicate(format: "postID == \(postID) AND voter == %@", User.current?.name ?? ""),
                                                     andSortDescriptor:         nil)?.first != nil
    }
    
    class func updateEntities(fromResponseAPI responseAPI: [Decodable], withPostID postID: Int64) {
        guard let models = responseAPI as? [ResponseAPIActiveVote], models.count > 0 else {
            return
        }
        
        for model in models {
            var entity  =   CoreDataManager.instance.readEntity(withName:                   "ActiveVote",
                                                                andPredicateParameters:     NSPredicate.init(format: "postID == \(postID) AND voter == %@", model.voter)) as? ActiveVote
            
            // Get ActiveVote entity
            if entity == nil {
                entity  =   CoreDataManager.instance.createEntity("ActiveVote") as? ActiveVote
            }
            
            // Update entity
            entity!.postID          =   postID
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
    }
}
