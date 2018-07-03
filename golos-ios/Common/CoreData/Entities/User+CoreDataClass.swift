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
    class var current: User? {
        get {
            return (CoreDataManager.instance.readEntity(withName: "User", andPredicateParameters: nil)) as? User
        }
    }
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let userModel           =   responseAPI as! ResponseAPIUser
        
        self.id                 =   userModel.id
        self.name               =   userModel.name
        self.post_count         =   userModel.post_count
        self.json_metadata      =   userModel.json_metadata
        
        // UserSecretMemoKey
        let userSecretKeyMemosEntity    =   UserSecretMemosKey.instance(byUserID: userModel.id)
        userSecretKeyMemosEntity.updateEntity(fromResponseAPI: userModel.memo)
        self.memos                      =   userSecretKeyMemosEntity

        // UserSecretPostingKey
        let userSecretKeyPostingEntity  =   UserSecretPostingKey.instance(byUserID: userModel.id)
        userSecretKeyPostingEntity.updateEntity(fromResponseAPI: userModel.posting)
        self.posting                    =   userSecretKeyPostingEntity
        
        // UserSecretOwnerKey
        let userSecretKeyOwnerEntity    =   UserSecretOwnerKey.instance(byUserID: userModel.id)
        userSecretKeyOwnerEntity.updateEntity(fromResponseAPI: userModel.owner)
        self.owner                      =   userSecretKeyOwnerEntity
        
        // Extensions
        self.save()
    }
}
