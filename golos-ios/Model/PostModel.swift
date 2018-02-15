//
//  PostModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    let postId: Int
    let title: String
    let body: String
//    let votes: [PostVoteModel]
    
    init?(postDictionary: [String: Any]) {
        guard let id = postDictionary["id"] as? Int,
            let title = postDictionary["title"] as? String,
            let body = postDictionary["body"] as? String else {
                return nil
        }
        
        self.postId = id
        self.title = title
        self.body = body
    }
}
