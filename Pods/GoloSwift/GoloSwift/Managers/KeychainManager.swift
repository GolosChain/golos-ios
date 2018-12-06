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
    public static func deleteData(forUserNickName userNickName: String, withKey key: String) -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userNickName, inService: key)
            Logger.log(message: "Successfully delete User data by key from Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Error delete User data by key from Keychain.", event: .error)
            return false
        }
    }
    
    public static func deleteAllData(forUserNickName userNickName: String) -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userNickName)
            Logger.log(message: "Successfully delete all User data from Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Delete error all User data from Keychain.", event: .error)
            return false
        }
    }
    
    
    /// Load data from Keychain
    public static func load(privateKey: String, forUserNickName userNickName: String) -> String? {
        var resultKey: String?
        
        if let data = Locksmith.loadDataForUserAccount(userAccount: userNickName, inService: privateKey) {
            resultKey = data[keyPrivate] as? String
        }
        
        return resultKey
    }
    
    public static func loadData(forUserNickName userNickName: String, withKey key: String) -> [String: Any]? {
        return Locksmith.loadDataForUserAccount(userAccount: userNickName, inService: key)
    }
    
    public static func loadAllData(forUserNickName userNickName: String) -> [String: Any]? {
        return Locksmith.loadDataForUserAccount(userAccount: userNickName)
    }
    
    
    /// Save login data to Keychain
    public static func save(data: [String: Any], userNickName: String) -> Bool {
        let keyData = data.keys.first ?? "XXX"
        
        do {
            if Locksmith.loadDataForUserAccount(userAccount: userNickName, inService: keyData) == nil {
                try Locksmith.saveData(data: data, forUserAccount: userNickName, inService: keyData)
            }
                
            else {
                try Locksmith.updateData(data: data, forUserAccount: userNickName, inService: keyData)
            }
            
            Logger.log(message: "Successfully save User data to Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Error save User data to Keychain.", event: .error)
            return false
        }
    }
}
