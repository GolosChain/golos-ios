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
    public static func deleteKey(byType type: PrivateKeyType, forUserName userName: String) -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userName)
            Logger.log(message: "Successfully delete Login data from Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Delete Login data from Keychain error.", event: .error)
            return false
        }
    }
    
    
    /// Load data from Keychain
    public static func loadPrivateKey(forUserName userName: String) -> String? {
        var privateKey: String?
        
        if let data = Locksmith.loadDataForUserAccount(userAccount: userName) {
            privateKey = data["privateKey"] as? String
        }
        
        return privateKey
    }
    
    
    /// Save login data to Keychain
    public static func save(_ key: String, forUserName userName: String) -> Bool {
        do {
            if loadPrivateKey(forUserName: userName) == nil {
                try Locksmith.saveData(data: [ "privateKey": key ], forUserAccount: userName)
            }
                
            else {
                try Locksmith.updateData(data: [ "privateKey": key ], forUserAccount: userName)
            }
            
            Logger.log(message: "Successfully save Login data to Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Save Login data to Keychain error.", event: .error)
            return false
        }
    }
}
