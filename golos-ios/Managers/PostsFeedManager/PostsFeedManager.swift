//
//  PostsFeedManager.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class PostsFeedManager {
    let webSocket = WebSocketManager.shared
    
    func loadFeed(with type: PostsFeedType, amount: Int, completion: @escaping ([PostModel], NSError?) -> Void) {
        let method = methodForPostsFeed(type: type)
        let parameters = ["limit": amount]
        
        webSocket.sendRequestWith(
            method: method,
            parameters: parameters
        ) { (result, error) in
            guard error == nil else {
                completion([], error!)
                return
            }
            
            guard let postsDictinary = result as? [[String: Any]] else {
                return
            }
            
            let posts = postsDictinary.flatMap({ postDictionary -> PostModel? in
                PostModel(postDictionary: postDictionary)
            })
            
            completion(posts, nil)
        }
    }
    
    private func methodForPostsFeed(type: PostsFeedType) -> WebSocketMethod {
        switch type {
        case .hot: return WebSocketMethod.getDiscussionsActual
        case .new: return WebSocketMethod.getDiscussionsNew
        case .popular: return WebSocketMethod.getDiscussionsPopular
        case .promoted: return WebSocketMethod.getDiscussionsActual
        }
    }
}
