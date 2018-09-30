//
//  KeychainManager.swift
//  GoloSwift
//
//  Created by msm72 on 22.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Locksmith
import Foundation

public class KeychainManager {
    /// Delete stored data from Keychain
    public static func deleteKey(byType type: PrivateKeyType, forUserNickName userNickName: String) -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userNickName)
            Logger.log(message: "Successfully delete Login data from Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Delete Login data from Keychain error.", event: .error)
            return false
        }
    }
    
    
    /// Load data from Keychain
    public static func loadPrivateKey(forUserNickName userNickName: String) -> String? {
        var privateKey: String?
        
        if let data = Locksmith.loadDataForUserAccount(userAccount: userNickName) {
            privateKey = data["privateKey"] as? String
        }
        
        return privateKey
    }
    
    
    /// Save login data to Keychain
    public static func save(key: String, userNickName: String) -> Bool {
        do {
            if loadPrivateKey(forUserNickName: userNickName) == nil {
                try Locksmith.saveData(data: [ "privateKey": key ], forUserAccount: userNickName)
            }
                
            else {
                try Locksmith.updateData(data: [ "privateKey": key ], forUserAccount: userNickName)
            }
            
            Logger.log(message: "Successfully save Login data to Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Save Login data to Keychain error.", event: .error)
            return false
        }
    }
}
