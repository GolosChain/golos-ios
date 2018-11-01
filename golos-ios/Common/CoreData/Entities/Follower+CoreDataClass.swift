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
    var modeValue: Int16? {
        set {}
        
        get {
            return self.mode
        }
    }
    
    var nameValue: String {
        set {}
        
        get {
            return self.modeValue == 0 ? self.follower : self.following
        }
    }
    
    var nickNameValue: String {
        set {}
        
        get {
            return self.modeValue == 0 ? self.follower : self.following
        }
    }
    
    var reputationValue: String {
        set {}
        
        get {
            return "0"
        }
    }

    
    // MARK: - Class Functions
    class func loadFollowers(byUserNickName userNickname: String, andPaginationPage paginationPage: Int16, forMode mode: UserFollowerMode) -> [Follower]? {
        return CoreDataManager.instance.readEntities(withName:                  "Follower",
                                                     withPredicateParameters:   NSPredicate(format: "%K == %@ AND paginationPage == \(paginationPage) AND mode == \(mode.rawValue)", mode == .followers ? "following" : "follower", userNickname),
                                                     andSortDescriptor:         nil) as? [Follower]
    }
    
    class func isUserFollower() -> Bool {
        return CoreDataManager.instance.readEntities(withName:                  "Follower",
                                                     withPredicateParameters:   NSPredicate(format: "follower == %@", User.current?.nickName ?? ""),
                                                     andSortDescriptor:         nil)?.first != nil
    }
    
    class func updateEntities(fromResponseAPI responseAPI: [Decodable], withPaginationPage paginationPage: Int16, inMode mode: UserFollowerMode) {
        guard let models = responseAPI as? [ResponseAPIUserFollowing], models.count > 0 else {
            return
        }
        
        for model in models {
            var entity  =   CoreDataManager.instance.readEntity(withName:                   "Follower",
                                                                andPredicateParameters:     NSPredicate.init(format: "follower == %@ AND following == %@ AND paginationPage == \(paginationPage) AND mode == \(mode.rawValue)", model.follower, model.following)) as? Follower
            
            // Get Follower entity
            if entity == nil {
                entity  =   CoreDataManager.instance.createEntity("Follower") as? Follower
            }
            
            // Update entity
            entity!.paginationPage  =   paginationPage
            entity!.follower        =   model.follower
            entity!.following       =   model.following
            entity!.what            =   model.what
            entity!.mode            =   Int16(mode.rawValue)
            
            // Extension
            entity!.save()
        }
    }
}
