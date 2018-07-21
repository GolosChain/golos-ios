//
//  Promo+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 17.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Promo)
public class Promo: NSManagedObject, PaginationSupport, MetaDataSupport, PostFeedCellSupport {
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
        let model   =   responseAPI as! ResponseAPIFeed
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Promo",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Promo
        
        // Get Promo entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Promo") as? Promo
        }
        
        // Update entity
        entity!.id                  =   model.id
        entity!.author              =   model.author
        entity!.category            =   model.category
        
        entity!.title               =   model.title
        entity!.body                =   model.body
        entity!.permlink            =   model.permlink
        entity!.allowVotes          =   model.allow_votes
        entity!.allowReplies        =   model.allow_replies
        entity!.jsonMetadata        =   model.json_metadata
        entity!.created             =   model.created.convert(toDateFormat: .expirationDateType)
        entity!.parentAuthor        =   model.parent_author
        entity!.parentPermlink      =   model.parent_permlink
        entity!.activeVotesCount    =   Int16(model.active_votes.count)
        entity!.url                 =   model.url
        
        // Extension: parse & save
        entity!.parse(metaData: model.json_metadata, fromModel: model)
    }
}
