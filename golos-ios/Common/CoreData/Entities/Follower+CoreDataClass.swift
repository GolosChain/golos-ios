//
//  Follower+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 10/31/18.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Follower)
public class Follower: NSManagedObject, UserCellSupport {
    // UserCellSupport protocol implementation
    var nameValue: String {
        set {}
        
        get {
            return self.follower
        }
    }
    
    var nickNameValue: String {
        set {}
        
        get {
            return self.follower
        }
    }
    
    var reputationValue: String {
        set {}
        
        get {
            return "0"
        }
    }

    
    // MARK: - Class Functions
    class func loadFollowers(byUserNickName userNickname: String, andPaginationPage paginationPage: Int16) -> [Follower]? {
        return CoreDataManager.instance.readEntities(withName:                  "Follower",
                                                     withPredicateParameters:   NSPredicate(format: "following == %@ AND paginationPage == \(paginationPage)", userNickname),
                                                     andSortDescriptor:         nil) as? [Follower]
    }
    
    class func isUserFollower() -> Bool {
        return CoreDataManager.instance.readEntities(withName:                  "Follower",
                                                     withPredicateParameters:   NSPredicate(format: "follower == %@", User.current?.nickName ?? ""),
                                                     andSortDescriptor:         nil)?.first != nil
    }
    
    class func updateEntities(fromResponseAPI responseAPI: [Decodable], withPaginationPage paginationPage: Int16) {
        guard let models = responseAPI as? [ResponseAPIUserFollowing], models.count > 0 else {
            return
        }
        
        for model in models {
            var entity  =   CoreDataManager.instance.readEntity(withName:                   "Follower",
                                                                andPredicateParameters:     NSPredicate.init(format: "paginationPage == \(paginationPage) AND follower == %@", model.follower)) as? Follower
            
            // Get Follower entity
            if entity == nil {
                entity  =   CoreDataManager.instance.createEntity("Follower") as? Follower
            }
            
            // Update entity
            entity!.paginationPage  =   paginationPage
            entity!.follower        =   model.follower
            entity!.following       =   model.following
            entity!.what            =   model.what
            
            // Extension
            entity!.save()
        }
    }
}
