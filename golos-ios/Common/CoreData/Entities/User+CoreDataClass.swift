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

enum VoicePower: String {
    case whale          =   "Whale"
    case gudgeon        =   "Gudgeon"
    case dolphin        =   "Dolphin"
    case killerWhale    =   "Killer-Whale"
    
    func introduced() -> String {
        return self.rawValue
    }
}

@objc(User)
public class User: NSManagedObject {
    // MARK: - Properties
    var voicePower: VoicePower {
        let powerVoice  =   Int64(self.vestingShares.components(separatedBy: ".").first!)! % 10_000_000
        
        switch powerVoice {
        case 0..<10_000_000:
            return VoicePower.gudgeon
       
        case 10_000_000..<100_000_000:
            return VoicePower.dolphin
        
        case 100_000_000..<1_000_000_000:
            return VoicePower.killerWhale
            
        default:
            return VoicePower.whale
        }
    }

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
    
    class func fetch(byName name: String) -> User? {
        return CoreDataManager.instance.readEntity(withName:                        "User",
                                                   andPredicateParameters:           NSPredicate(format: "name == %@", name)) as? User
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
        if let userModel = responseAPI as? ResponseAPIUser {
            self.id             =   userModel.id
            self.name           =   userModel.name
            self.postsCount     =   userModel.post_count
            self.json_metadata  =   userModel.json_metadata
            self.memoKey        =   userModel.memo_key
            self.vestingShares  =   userModel.vesting_shares
            self.reputation     =   userModel.reputation.stringValue!
            self.canVote        =   userModel.can_vote
            self.commentCount   =   userModel.comment_count
            self.created        =   userModel.created
            
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
            
            // Parse 'json_metadata'
            if let metaData = userModel.json_metadata {
                self.parse(metaData: metaData)
            }
        }
        
        if let userFollowModel = responseAPI as? ResponseAPIUserFollowCounts {
            self.followerCount      =   userFollowModel.follower_count
            self.followingCount     =   userFollowModel.following_count
            self.followingLimit     =   userFollowModel.limit
        }
        
        // Extensions
        self.save()
    }
    
    
    // MARK: - Custom Functions
    func setIsAuthorized(_ value: Bool) {
        self.isAuthorized = value
        self.save()
    }
    
    private func parse(metaData: String) {
        if  let data    =   metaData.data(using: .utf8),
            let json    =   try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let profile =   json?["profile"] as? [String: Any] {
            self.about              =   profile["about"] as? String
            self.gender             =   profile["gender"] as? String
            self.profileImageURL    =   profile["profile_image"] as? String
            self.coverImageURL      =   profile["cover_image"] as? String
            self.selectTags         =   profile["select_tags"] as? [String]
        }
    }
    
    func clearCache() {
        CoreDataManager.instance.deleteEntities(withName: "Actual", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Blog", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Lenta", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "New", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Popular", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Promo", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Reply", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "User", andPredicateParameters: NSPredicate(format: "isAuthorized == 0"), completion: { _ in })
    }
}
