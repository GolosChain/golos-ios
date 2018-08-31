//
//  NSManagedObject+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 23.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

extension NSManagedObject {
    func save() {
        CoreDataManager.instance.contextSave()
    }
    
    func update(withModel model: ResponseAPIPost) {
        if var entity = self as? PostCellSupport {
            entity.id                   =   model.id
            entity.author               =   model.author
            entity.category             =   model.category
            
            entity.title                =   model.title
            entity.permlink             =   model.permlink
            entity.allowVotes           =   model.allow_votes
            entity.allowReplies         =   model.allow_replies
            entity.jsonMetadata         =   model.json_metadata
            entity.active               =   model.active.convert(toDateFormat: .expirationDateType)
            entity.created              =   model.created.convert(toDateFormat: .expirationDateType)
            entity.lastUpdate           =   model.last_update.convert(toDateFormat: .expirationDateType)
            entity.lastPayout           =   model.last_payout.convert(toDateFormat: .expirationDateType)
            entity.parentAuthor         =   model.parent_author
            entity.parentPermlink       =   model.parent_permlink
            entity.activeVotesCount     =   Int16(model.active_votes.count)
            entity.url                  =   model.url
            entity.pendingPayoutValue   =   (model.pending_payout_value as NSString).floatValue
            entity.children             =   model.children
            
            if let authorReputation = model.author_reputation.stringValue {
                entity.authorReputation =   authorReputation
            }
            
            if let rebloggedBy = model.reblogged_by, rebloggedBy.count > 0 {
                entity.rebloggedBy      =   rebloggedBy
            }
            
            // Modify body
            entity.body                 =   model.body
                                                .convertImagePathToMarkdown()
                                                .convertUsersAccounts()

            // Set ActiveVote values
            if let activeVotes = ActiveVote.updateEntities(fromResponseAPI: model.active_votes, withParentID: model.id) {
                entity.activeVotes      =   NSSet(array: activeVotes)
            }
            
            // Extension: parse & save
            self.parse(metaData: model.json_metadata, fromBody: model.body)
        }
    }
    
    func parse(metaData: String?, fromBody body: String) {
        if let jsonMetaData = metaData, !jsonMetaData.isEmpty, let jsonData = jsonMetaData.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                    (self as! MetaDataSupport).set(tags: json["tags"] as? [String])
                    
                    if let imageURL = (json["image"] as? [String])?.first {
                        (self as! MetaDataSupport).set(coverImageURL: imageURL)
                    }
                        
                    else {
                        do {
                            let input       =   body
                            let detector    =   try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                            let matches     =   detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                            
                            for match in matches {
                                guard let range = Range(match.range, in: input) else {
                                    continue
                                }
                                
                                let url     =   input[range]
                                
                                Logger.log(message: "url = \(url)", event: .debug)
                                
                                if (url.hasSuffix(".jpg") || url.hasSuffix(".png") || url.hasSuffix(".gif")) && (self as! MetaDataSupport).coverImageURL == nil {
                                    (self as! MetaDataSupport).set(coverImageURL: "\(url)")
                                    Logger.log(message: "coverImageURL = \(url)", event: .debug)
                                }
                            }
                        } catch {
                            // contents could not be loaded
                            (self as! MetaDataSupport).set(coverImageURL: nil)
                        }
                    }
                    
                    // Extensions
                    self.save()
                }
            } catch {
                Logger.log(message: "JSON serialization error", event: .error)
                
                // Extensions
                self.save()
            }
        }
            
        else {
            // Extensions
            self.save()
        }
    }
}
