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
    class func updateEntity(fromResponseAPI responseAPI: Decodable, andPostsFeedType type: PostsFeedType) {
        let postModel       =   responseAPI as! ResponseAPIFeed
        var postEntity      =   CoreDataManager.instance.readEntity(withName: "Post",
                                                                    andPredicateParameters: NSPredicate.init(format: "id == \(postModel.id) AND feedType == %@", type.rawValue)) as? Post
        
        // Get Post entity
        if postEntity == nil {
            postEntity      =   CoreDataManager.instance.createEntity("Post") as? Post
        }
        
        // Update entity
        postEntity!.feedType        =   type.rawValue
        postEntity!.id              =   postModel.id
        postEntity!.author          =   postModel.author
        postEntity!.category        =   postModel.category
        
        postEntity!.title           =   postModel.title
        postEntity!.body            =   postModel.body
        postEntity!.permlink        =   postModel.permlink
        postEntity!.allowVotes      =   postModel.allow_votes
        postEntity!.allowReplies    =   postModel.allow_replies
        postEntity!.jsonMetadata    =   postModel.json_metadata
        
        // Extensions
        postEntity!.save()
    }
}
