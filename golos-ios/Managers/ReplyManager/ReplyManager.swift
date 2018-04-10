//
//  ReplyManager.swift
//  Golos
//
//  Created by Grigory on 28/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class ReplyManager {
    // MARK: - Custom Functions
    func loadRepliesForPost(withPermalink permalink: String, authorUsername: String, completion: @escaping ([PostReplyModel], NSError?) -> Void) {
        let method = methodForUserRequest(.getPostReplies)
        let parameters = [authorUsername, permalink]
        
        webSocket.sendRequestWith(method: method, parameters: parameters) { result, error in
            guard error == nil else {
                completion([], error!)
                return
            }
            
            guard let replyArray = result as? [[String: Any]] else {
                return
            }
            
            let replies = replyArray.compactMap({ replyDictionary -> PostReplyModel? in
                PostReplyModel(replyDictionary: replyDictionary)
            })

            completion(replies, nil)
        }
    }

    private func methodForUserRequest(_ request: ReplyRequestType) -> WebSocketMethod {
        switch request {
        case .getPostReplies:
            return WebSocketMethod.getPostReplies
        }
    }
}
