//
//  PostCommentModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct PostReplyModel: Codable {
    let replyId: Int
    let author: String
    let body: String
    
    init?(replyDictionary: [String: Any]) {
        guard let codeID = replyDictionary["id"] as? Int,
            let author = replyDictionary["author"] as? String,
            let body = replyDictionary["body"] as? String else {
                return nil
        }
        
        self.replyId = codeID
        self.author = author
        self.body = body
    }
}
