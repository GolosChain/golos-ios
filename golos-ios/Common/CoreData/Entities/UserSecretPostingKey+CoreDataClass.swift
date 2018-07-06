//
//  UserSecretPostingKey+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(UserSecretPostingKey)
public class UserSecretPostingKey: NSManagedObject {
    // MARK: - Class Functions
    class func instance(byUserID userID: Int64) -> UserSecretPostingKey {
        if let userSecretPostingKey = CoreDataManager.instance.readEntity(withName: "UserSecretPostingKey", andPredicateParameters: NSPredicate.init(format: "userID == \(userID)")) as? UserSecretPostingKey {
            return userSecretPostingKey
        }
        
        let userSecretPostingKeyEntity      =   CoreDataManager.instance.createEntity("UserSecretPostingKey") as! UserSecretPostingKey
        userSecretPostingKeyEntity.userID   =   userID
        
        return userSecretPostingKeyEntity
    }
    
    func updateEntity(fromResponseAPI responseAPI: Decodable) {
        if let userSecretKeyModel = responseAPI as? ResponseAPIUserSecretKey {
            self.account_auths      =   userSecretKeyModel.account_auths.compactMap({ $0.stringValue ?? "" })
            self.weight_threshold   =   userSecretKeyModel.weight_threshold ?? 0
            
            if userSecretKeyModel.key_auths.count > 0 {
                var keyAuths        =   [String]()
                
                for key_auth in userSecretKeyModel.key_auths[0] {
                    if let value = key_auth.stringValue {
                        keyAuths.append(value)
                    }
                }
                
                self.key_auths      =   [keyAuths]
            }
        }
    }
}
