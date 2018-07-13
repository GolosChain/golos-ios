//
//  Lenta+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Lenta)
public class Lenta: NSManagedObject {
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let lentaModel      =   responseAPI as! ResponseAPIFeed
        var lentaEntity     =   CoreDataManager.instance.readEntity(withName: "Lenta",
                                                                    andPredicateParameters: NSPredicate.init(format: "id == \(lentaModel.id)")) as? Lenta
        
        // Get Lenta entity
        if lentaEntity == nil {
            lentaEntity     =   CoreDataManager.instance.createEntity("Lenta") as? Lenta
        }
        
        // Update entity
        lentaEntity!.id                 =   lentaModel.id
        lentaEntity!.author             =   lentaModel.author
        lentaEntity!.category           =   lentaModel.category
        
        lentaEntity!.title              =   lentaModel.title
        lentaEntity!.body               =   lentaModel.body
        lentaEntity!.permlink           =   lentaModel.permlink
        lentaEntity!.allowVotes         =   lentaModel.allow_votes
        lentaEntity!.allowReplies       =   lentaModel.allow_replies
        lentaEntity!.jsonMetadata       =   lentaModel.json_metadata
        lentaEntity!.created            =   lentaModel.created.convert(toDateFormat: .expirationDateType)
        lentaEntity!.parentAuthor       =   lentaModel.parent_author
        lentaEntity!.parentPermlink     =   lentaModel.parent_permlink
        lentaEntity!.activeVotesCount   =   Int16(lentaModel.active_votes.count)
        lentaEntity!.url                =   lentaModel.url

        if let jsonMetaData = lentaModel.json_metadata, let jsonData = jsonMetaData.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                    lentaEntity!.tags           =   json["tags"] as? [String]
                    lentaEntity!.coverImageURL  =   (json["image"] as? [String])?.first
                }
            } catch {
                Logger.log(message: "JSON serialization error", event: .error)
            }
        }

        // Extensions
        lentaEntity!.save()
    }
}
