//
//  PostModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct PostModel {
    let postId: Int
    let title: String
    let body: String
    let description: String
    let pictureUrl: String?
    let category: String
    let authorName: String
    var reblogAuthorName: String? = nil
    let isVoteAllow: Bool
    let isCommentAllow: Bool
    let permalink: String
    let tags: [String]
    let votes: [PostVoteModel]
    var replies: [PostReplyModel]?
    var author: UserModel?
    
    
    
    init?(postDictionary: [String: Any]) {
        guard let id = postDictionary["id"] as? Int,
            let title = postDictionary["title"] as? String,
            let body = postDictionary["body"] as? String else {
                return nil
        }
        
        let parser = PostParser()
        let desciption = parser.getDescription(from: body)
        let pictureUrl = parser.getPictureUrl(from: body)
        
        self.postId = id
        self.title = title
        self.body = body
        self.pictureUrl = pictureUrl
        self.description = desciption
        self.category = postDictionary["category"] as? String ?? ""
        self.authorName = postDictionary["author"] as? String ?? ""
        self.isCommentAllow = (postDictionary["allow_replies"] as? Int) == 1 ? true : false
        self.isVoteAllow = (postDictionary["allow_votes"] as? Int) == 1 ? true : false
        self.permalink = postDictionary["permlink"] as? String ?? ""
        
        if let votes = postDictionary["active_votes"] as? [[String: Any]] {
            let voteModels = votes.map({ voteDictionary -> PostVoteModel in
                let voter = voteDictionary["voter"] as? String ?? ""
                return PostVoteModel(voter: voter, time: Date())
            })
            self.votes = voteModels
        } else {
            votes = []
        }
        
        let tags: [String]
        if let metadataString = postDictionary["json_metadata"] as? String,
            let data = metadataString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            
            
            tags = json?["tags"] as? [String] ?? [String]()
        } else {
            tags = [String]()
        }
        self.tags = tags
    }
}
