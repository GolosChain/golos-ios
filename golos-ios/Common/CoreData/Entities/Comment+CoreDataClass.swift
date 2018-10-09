//
//  Comment+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 08.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Comment)
public class Comment: NSManagedObject, CachedImageFrom {
    var treeIndex: Int = 0
    var treeLevel: Int = 0
    
    // MARK: - CachedImageFrom protocol implementation
    var fromItem: String = "comment"
    
    // MARK: - MetaDataSupport protocol implementation
    func set(tags: [String]?) {
        self.tags   =   tags
    }
    
    func set(coverImageURL: String?) {
        self.coverImageURL = coverImageURL
    }
    
    
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let model   =   responseAPI as! ResponseAPIAllContentReply
        
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Comment",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Comment
        
        // Get Comment entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Comment") as? Comment
        }
        
        // Update entity
        entity!.id                  =   model.id
        entity!.author              =   model.author
        entity!.category            =   model.category
        
        entity!.title               =   model.title
        entity!.permlink            =   model.permlink
        entity!.active              =   model.active.convert(toDateFormat: .expirationDateType)
        entity!.created             =   model.created.convert(toDateFormat: .expirationDateType)
        entity!.lastUpdate          =   model.last_update.convert(toDateFormat: .expirationDateType)
        entity!.lastPayout          =   model.last_payout.convert(toDateFormat: .expirationDateType)
        entity!.parentAuthor        =   model.parent_author
        entity!.parentPermlink      =   model.parent_permlink
        entity!.url                 =   model.url
        entity!.rebloggedBy         =   model.reblogged_by
        
        // Modify body
        entity!.body                =   model.body
                                            .convertImagePathToMarkdown()
                                            .convertUsersAccounts()
        
        // Extension: parse & save
        (entity! as NSManagedObject).parse(metaData: model.json_metadata, fromBody: model.body)
    }
}
