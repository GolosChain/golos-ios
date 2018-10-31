//
//  Voter+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 10/26/18.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Voter)
public class Voter: NSManagedObject, UserCellSupport {
    // UserCellSupport protocol implementation
    var nameValue: String {
        set {}
        
        get {
            return self.voter
        }
    }
    
    var nickNameValue: String {
        set {}
        
        get {
            return self.voter
        }
    }
    
    var reputationValue: String {
        set {}
        
        get {
            return self.reputation
        }
    }

    
    // MARK: - Class Functions
    class func loadVoters(byPostID postID: Int64) -> [Voter]? {
        return CoreDataManager.instance.readEntities(withName:                  "Voter",
                                                     withPredicateParameters:   NSPredicate(format: "postID == \(postID)"),
                                                     andSortDescriptor:         nil) as? [Voter]
    }
    
    class func isUserVoter(currentPost postID: Int64) -> Bool {
        return CoreDataManager.instance.readEntities(withName:                  "Voter",
                                                     withPredicateParameters:   NSPredicate(format: "postID == \(postID) AND voter == %@", User.current?.nickName ?? ""),
                                                     andSortDescriptor:         nil)?.first != nil
    }
    
    class func updateEntities(fromResponseAPI responseAPI: [Decodable], withPostID postID: Int64) {
        guard let models = responseAPI as? [ResponseAPIVoter], models.count > 0 else {
            return
        }
        
        for model in models {
            var entity  =   CoreDataManager.instance.readEntity(withName:                   "Voter",
                                                                andPredicateParameters:     NSPredicate.init(format: "postID == \(postID) AND voter == %@", model.voter)) as? Voter
            
            // Get Voter entity
            if entity == nil {
                entity  =   CoreDataManager.instance.createEntity("Voter") as? Voter
            }
            
            // Update entity
            entity!.postID          =   postID
            entity!.voter           =   model.voter
            entity!.percent         =   model.percent
            entity!.rshares         =   model.rshares.stringValue!
            entity!.weight          =   model.weight.stringValue!
            entity!.time            =   model.time
            entity!.reputation      =   model.reputation.stringValue!

            // Extension
            entity!.save()
        }
    }
}
