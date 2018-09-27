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
public class User: NSManagedObject, CachedImageFrom {
    // MARK: - CachedImageFrom protocol implementation
    var fromItem: String    =   "user"
    var profileName: String?
    
    
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
        userEntity.save()

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
            userSecretKeyActiveEntity.updateEntity(fromResponseAPI: userModel.active)
            self.active                     =   userSecretKeyActiveEntity
            
            // Parse 'json_metadata'
            if let metaData = userModel.json_metadata {
                self.parse(metaData: metaData)
            }
        }
        
        if let userFollowModel = responseAPI as? ResponseAPIUserFollowCounts {
            self.followerCount      =   Int64(userFollowModel.follower_count)
            self.followingCount     =   Int64(userFollowModel.following_count)
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
            self.profileName        =   profile["name"] as? String
        }
    }
    
    class func clearCache(atLastWeek needPredicate: Bool) {
        var predicate: NSPredicate?
        var predicateImage: NSPredicate?

        if let dateLastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) as NSDate?, needPredicate {
            predicate       =   NSPredicate(format: "created <= %@", dateLastWeek)
            predicateImage  =   NSPredicate(format: "created <= %@ AND fromItem != \"lenta\"", dateLastWeek)
        }
        
        CoreDataManager.instance.deleteEntities(withName: "Actual", andPredicateParameters: predicate, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "New", andPredicateParameters: predicate, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Popular", andPredicateParameters: predicate, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Promo", andPredicateParameters: predicate, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Reply", andPredicateParameters: predicate, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Comment", andPredicateParameters: predicate, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "ImageCached", andPredicateParameters: predicateImage, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Blog", andPredicateParameters: predicate, completion: { _ in })
    }
    
    class func clearCache() {
        CoreDataManager.instance.deleteEntities(withName: "ActiveVote", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "ImageCached", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "Lenta", andPredicateParameters: nil, completion: { _ in })
        CoreDataManager.instance.deleteEntities(withName: "User", andPredicateParameters: NSPredicate(format: "isAuthorized == 0"), completion: { _ in })
        
        self.clearCache(atLastWeek: false)
    }
}
