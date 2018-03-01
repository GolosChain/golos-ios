//
//  PostsManager.swift
//  Golos
//
//  Created by Grigory on 28/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class PostsManager {
    let webSocket = WebSocketManager.shared
    
    func loadPost(withPermalink permalink: String,
                  authorUsername: String,
                  completion: @escaping (PostModel?, NSError?) -> Void) {
        let method = methodForPostRequest(.getPost)
        let parameters = [authorUsername, permalink]
        
        webSocket.sendRequestWith(method: method, parameters: parameters) { result, error in
            guard error == nil else {
                completion(nil, error!)
                return
            }

            guard let result = result as? [String: Any] else {
                return
            }
            
            let post = PostModel(postDictionary: result)
            completion(post, nil)
        }
    }
    
    private func methodForPostRequest(_ request: PostRequestType) -> WebSocketMethod {
        switch request {
        case .getPost: return WebSocketMethod.getPost
        }
    }
//    
//    func loadRepliesForPost(withPermalink permalink: String,
//                            authorUsername: String,
//                            completion: @escaping ([PostReplyModel], NSError?) -> Void) {
//        let method = methodForUserRequest(.getPostReplies)
//        let parameters = [authorUsername, permalink]
//        
//        webSocket.sendRequestWith(method: method, parameters: parameters) { result, error in
//            guard error == nil else {
//                completion([], error!)
//                return
//            }
//            
//            guard let replyArray = result as? [[String: Any]] else {
//                return
//            }
//            
//            let replies = replyArray.flatMap({ replyDictionary -> PostReplyModel? in
//                PostReplyModel(replyDictionary: replyDictionary)
//            })
//            
//            completion(replies, nil)
//        }
//    }
//    
//    private func methodForUserRequest(_ request: ReplyRequestType) -> WebSocketMethod {
//        switch request {
//        case .getPostReplies: return WebSocketMethod.getPostReplies
//        }
//    }
}
