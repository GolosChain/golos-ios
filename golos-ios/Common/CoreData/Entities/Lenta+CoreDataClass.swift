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

protocol PaginationSupport {
    var authorValue: String? { get }
    var permlinkValue: String { get }
}

@objc(Lenta)
public class Lenta: NSManagedObject, PaginationSupport {
    // MARK: - Properties
    var authorValue: String? {
        return self.author
    }
    
    var permlinkValue: String {
        return self.permlink
    }

    
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let model   =   responseAPI as! ResponseAPIFeed
        var entity  =   CoreDataManager.instance.readEntity(withName:                   "Lenta",
                                                            andPredicateParameters:     NSPredicate.init(format: "id == \(model.id)")) as? Lenta
        
        // Get Lenta entity
        if entity == nil {
            entity  =   CoreDataManager.instance.createEntity("Lenta") as? Lenta
        }
        
        // Update entity
        entity!.userName            =   User.current!.name
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

        if let jsonMetaData = model.json_metadata, !jsonMetaData.isEmpty, let jsonData = jsonMetaData.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                    entity!.tags           =   json["tags"] as? [String]
                    
                    if let imageURL = (json["image"] as? [String])?.first {
                        entity!.coverImageURL   =    imageURL
                    }
                    
                    else {
                        do {
                            let input       =   model.body
                            let detector    =   try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                            let matches     =   detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                            
                            for match in matches {
                                guard let range     =   Range(match.range, in: input) else { continue }
                                let url             =   input[range]
                                
                                Logger.log(message: "url = \(url)", event: .debug)

                                if (url.hasSuffix(".jpg") || url.hasSuffix(".png") || url.hasSuffix(".gif")) && entity!.coverImageURL == nil {
                                    entity!.coverImageURL   =   "\(url)"
                                    Logger.log(message: "coverImageURL = \(url)", event: .debug)
                                }
                            }
                        } catch {
                            // contents could not be loaded
                            entity!.coverImageURL   =   nil
                        }
                    }
                    
                    // Extensions
                    entity!.save()
                }
            } catch {
                Logger.log(message: "JSON serialization error", event: .error)
                
                // Extensions
                entity!.save()
            }
        }

        else {
            // Extensions
            entity!.save()
        }
    }
}
