//
//  UserSecretKey+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(UserSecretMemosKey)
public class UserSecretMemosKey: NSManagedObject {
    // MARK: - Class Functions
    class func instance(byUserID userID: Int64) -> UserSecretMemosKey {
        if let userSecretMemosKey = CoreDataManager.instance.readEntity(withName: "UserSecretMemosKey", andPredicateParameters: NSPredicate.init(format: "userID == \(userID)")) as? UserSecretMemosKey {
            return userSecretMemosKey
        }
        
        let userSecretMemosKeyEntity     =   CoreDataManager.instance.createEntity("UserSecretMemosKey") as! UserSecretMemosKey
        userSecretMemosKeyEntity.userID  =   userID
        
        return userSecretMemosKeyEntity
    }

    func updateEntity(fromResponseAPI responseAPI: Decodable) {
        if let userSecretKeyModel = responseAPI as? ResponseAPIUserSecretKey {
            self.account_auths      =   userSecretKeyModel.account_auths
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
