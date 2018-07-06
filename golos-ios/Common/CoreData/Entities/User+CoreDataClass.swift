//
//  User+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(User)
public class User: NSManagedObject {
    // MARK: - Properties
    class var isAnonymous: Bool {
        get {
            return CoreDataManager.instance.readEntities(withName:                  "User",
                                                         withPredicateParameters:   NSPredicate(format: "isAuthorized = 1"),
                                                         andSortDescriptor:         nil)?.first == nil
        }
    }
    
    class var current: User? {
        get {
            return CoreDataManager.instance.readEntities(withName:                  "User",
                                                         withPredicateParameters:   NSPredicate(format: "isAuthorized = 1"),
                                                         andSortDescriptor:         nil)?.first as? User
        }
    }
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    class func instance(byUserID userID: Int64) -> User {
        if let user = CoreDataManager.instance.readEntity(withName: "User", andPredicateParameters: NSPredicate.init(format: "id == \(userID)")) as? User {
            return user
        }
        
        let userEntity          =   CoreDataManager.instance.createEntity("User") as! User
        userEntity.id           =   userID
        
        return userEntity
    }

    func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let userModel           =   responseAPI as! ResponseAPIUser
        
        self.id                 =   userModel.id
        self.name               =   userModel.name
        self.post_count         =   userModel.post_count
        self.json_metadata      =   userModel.json_metadata
        self.memoKey            =   userModel.memo_key
        
        // UserSecretPostingKey
        let userSecretKeyPostingEntity  =   UserSecretPostingKey.instance(byUserID: userModel.id)
        userSecretKeyPostingEntity.updateEntity(fromResponseAPI: userModel.posting)
        self.posting                    =   userSecretKeyPostingEntity
        
        // UserSecretOwnerKey
        let userSecretKeyOwnerEntity    =   UserSecretOwnerKey.instance(byUserID: userModel.id)
        userSecretKeyOwnerEntity.updateEntity(fromResponseAPI: userModel.owner)
        self.owner                      =   userSecretKeyOwnerEntity
        
        // UserSecretActiveKey
        let userSecretKeyActiveEntity   =   UserSecretActiveKey.instance(byUserID: userModel.id)
        userSecretKeyActiveEntity.updateEntity(fromResponseAPI: userModel.owner)
        self.active                     =   userSecretKeyActiveEntity
        
        // Extensions
        self.save()
    }
    
    
    // MARK: - Custom Functions
    func setIsAuthorized(_ value: Bool) {
        self.isAuthorized = value
        self.save()
    }
}
