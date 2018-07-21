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
public class Reply: NSManagedObject, PaginationSupport, MetaDataSupport, PostFeedCellSupport {
    // MARK: - PostFeedCellSupport protocol implementation
    var tagsValue: [String]? {
        return self.tags
    }
    
    var titleValue: String {
        return self.title
    }
    
    var categoryValue: String {
        return self.category
    }
    
    var allowVotesValue: Bool {
        return self.allowVotes
    }
    
    var allowRepliesValue: Bool {
        return self.allowReplies
    }
    
    
    // MARK: - PaginationSupport protocol implementation
    var authorValue: String {
        return self.author
    }
    
    var permlinkValue: String {
        return self.permlink
    }
    
    
    // MARK: - MetaDataSupport protocol implementation
    var coverImageURLValue: String? {
        return self.coverImageURL
    }
    
    func set(tags: [String]?) {
        self.tags   =   tags
    }
    
    func set(coverImageURL: String?) {
        self.coverImageURL = coverImageURL
    }
    
    
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let replyModel      =   responseAPI as! ResponseAPIFeed
        var replyEntity     =   CoreDataManager.instance.readEntity(withName:                   "Reply",
                                                                    andPredicateParameters:     NSPredicate.init(format: "id == \(replyModel.id)")) as? Reply
        
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

        // Extension: parse & save
        replyEntity!.parse(metaData: replyModel.json_metadata, fromModel: replyModel)
    }
}
