//
//  Reply+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Reply)
public class Reply: NSManagedObject, LoadUserProtocol {
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let replyModel      =   responseAPI as! ResponseAPIFeed
        var replyEntity     =   CoreDataManager.instance.readEntity(withName: "Reply",
                                                                    andPredicateParameters: NSPredicate.init(format: "id == \(replyModel.id)")) as? Reply
        
        // Get Reply entity
        if replyEntity == nil {
            replyEntity     =   CoreDataManager.instance.createEntity("Reply") as? Reply
        }
        
        // Update entity
        replyEntity!.id                 =   replyModel.id
        replyEntity!.author             =   replyModel.author
        replyEntity!.category           =   replyModel.category
        
        replyEntity!.title              =   replyModel.title
        replyEntity!.body               =   replyModel.body
        replyEntity!.permlink           =   replyModel.permlink
        replyEntity!.allowVotes         =   replyModel.allow_votes
        replyEntity!.allowReplies       =   replyModel.allow_replies
        replyEntity!.jsonMetadata       =   replyModel.json_metadata
        replyEntity!.created            =   replyModel.created.convert(toDateFormat: .expirationDateType)
        replyEntity!.parentAuthor       =   replyModel.parent_author
        replyEntity!.parentPermlink     =   replyModel.parent_permlink
        replyEntity!.activeVotesCount   =   Int16(replyModel.active_votes.count)
        replyEntity!.url                =   replyModel.url

        // Use default LoadUserProtocol implementation
        replyEntity!.loadUserInfo(byName: replyModel.author, completion: { user, errorAPI in
            guard errorAPI == nil else {
                Logger.log(message: errorAPI!.localizedDescription, event: .error)
                replyEntity!.save()
                return
            }

            replyEntity!.commentator    =   user!
            
            // Extensions
            replyEntity!.save()
        })
    }
}
