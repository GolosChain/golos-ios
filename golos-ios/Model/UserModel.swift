//
//  UserModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct UserModel {
    let userId: Int
    let name: String
    let pictureUrl: String?
    
    init?(userDictionary: [String: Any]) {
        guard let id = userDictionary["id"] as? Int,
            let name = userDictionary["name"] as? String
//            ,
//        let metadata = userDictionary["json_metadata"] as? [String: Any],
//            let profile = metadata["profile"] as? [String: Any],
//            let pictureUrl = profile["profile_image"] as? String
            else {
                return nil
        }
        
        let a = (userDictionary as NSDictionary).value(forKeyPath: "json_metadata.profile")
        self.userId = id
        self.name = name
        self.pictureUrl = ""
        
//        let parser = PostParser()
//        let desciption = parser.getDescription(from: body)
//        let pictureUrl = parser.getPictureUrl(from: body)
//
//        self.postId = id
//        self.title = title
//        self.body = body
//        self.pictureUrl = pictureUrl
//        self.description = desciption
//        self.category = postDictionary["category"] as? String ?? ""
//        self.authorName = postDictionary["author"] as? String ?? ""
//        self.isCommentAllow = (postDictionary["allow_replies"] as? Int) == 1 ? true : false
//        self.isVoteAllow = (postDictionary["allow_votes"] as? Int) == 1 ? true : false
//
//        if let votes = postDictionary["active_votes"] as? [[String: Any]] {
//            let voteModels = votes.map({ voteDictionary -> PostVoteModel in
//                let voter = voteDictionary["voter"] as? String ?? ""
//                return PostVoteModel(voter: voter, time: Date())
//            })
//            self.votes = voteModels
//        } else {
//            votes = []
//        }
    }
    
}
