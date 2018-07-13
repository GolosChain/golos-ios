//
//  Post+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 09.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(Post)
public class Post: NSManagedObject {
    // MARK: - Class Functions
    class func updateEntity(fromResponseAPI responseAPI: Decodable) {
        let postModel       =   responseAPI as! ResponseAPIFeed
        var postEntity      =   CoreDataManager.instance.readEntity(withName: "Post",
                                                                    andPredicateParameters: NSPredicate.init(format: "id == \(postModel.id)")) as? Post
        
        // Get Post entity
        if postEntity == nil {
            postEntity      =   CoreDataManager.instance.createEntity("Post") as? Post
        }
        
        // Update entity
        postEntity!.id                  =   postModel.id
        postEntity!.author              =   postModel.author
        postEntity!.category            =   postModel.category
        
        postEntity!.title               =   postModel.title
        postEntity!.body                =   postModel.body
        postEntity!.permlink            =   postModel.permlink
        postEntity!.allowVotes          =   postModel.allow_votes
        postEntity!.allowReplies        =   postModel.allow_replies
        postEntity!.jsonMetadata        =   postModel.json_metadata
        postEntity!.created             =   postModel.created.convert(toDateFormat: .expirationDateType)
        postEntity!.parentAuthor        =   postModel.parent_author
        postEntity!.parentPermlink      =   postModel.parent_permlink
        postEntity!.activeVotesCount    =   Int16(postModel.active_votes.count)
        postEntity!.url                 =   postModel.url

        if let jsonMetaData = postModel.json_metadata, !jsonMetaData.isEmpty, let jsonData = jsonMetaData.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                    postEntity!.tags            =   json["tags"] as? [String]
                    postEntity!.coverImageURL   =   (json["image"] as? [String])?.first
                    
                    // Extensions
                    postEntity!.save()
                }
            } catch {
                Logger.log(message: "JSON serialization error", event: .error)

                // Extensions
                postEntity!.save()
            }
        }
        
        else {
            // Extensions
            postEntity!.save()
        }
    }
}
