//
//  DisplayedPost.swift
//  Golos
//
//  Created by msm72 on 17.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

//reblogAuthorName:    postModel.reblogAuthorName,          String?
//commentsAmount:      postModel.replies == nil ? "-" :"\(postModel.replies!.count)",   String
//didComment:          postModel.isCommentAllow)            Bool

/// Model of displayed Post: copy the ResponseAPIFeed
struct DisplayedPost {
    // MARK: - Properties
    let id: Int64
    let title: String
    let category: String
    let authorName: String
    let authorCoverImageURL: String?
    let authorAvatarURL: String?
    let imagePictureURL: String?
    let body: String
    

    // TODO: - PRECISE
//    var reblogAuthorName: String?

    let allowVotes: Bool
    let allowReplies: Bool
    let permlink: String
    let description: String
//    let activeVotesCount: String
    var tags: [String]?
//    let repliesCount: String
    
    var author: DisplayedUser?
//    let activeVotes: [ResponseAPIActiveVote]?
//    let replies: [PostReplyModel]?
    
    
    // MARK: - Class Initialization
    init(fromResponseAPIFeed feed: ResponseAPIFeed) {
        let parser                  =   Parser()

        self.id                     =   feed.id
        self.title                  =   feed.title
        self.body                   =   feed.body
        self.category               =   feed.category
        self.authorName             =   feed.author
        self.authorCoverImageURL    =   author?.coverImageURL
        self.authorAvatarURL        =   author?.pictureURL
        self.imagePictureURL        =   parser.getPictureURL(from: feed.body)
        self.allowVotes             =   feed.allow_votes
        self.allowReplies           =   feed.allow_replies
        self.permlink               =   feed.permlink
        self.description            =   parser.getDescription(from: feed.body)
        
//        self.activeVotes            =   feed.active_votes
//        self.activeVotesCount       =   String(format: "%i", feed.active_votes.count)
        
        if let jsonMetaData = feed.json_metadata, let jsonData = jsonMetaData.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                    self.tags       =   json["tags"] as? [String]
                }
            } catch {
                Logger.log(message: "JSON serialization error", event: .error)
            }
        }
    }
}


//struct PostsFeedViewModel {
//    let tags: [String]
//    let commentsAmount: String
//}
