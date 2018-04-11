//
//  PostsFeedManager.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class PostsFeedManager {
    // MARK: - Custom Functions
    func loadFeed(with type: PostsFeedType, amount: Int, completion: @escaping ([PostModel], NSError?) -> Void) {
        Logger.log(message: "Success", event: .severe)

        let method = methodForPostsFeed(type: type)
        let parameters = ["limit": amount]
        
        Logger.log(message: "method = \(method), parameters = \(parameters)", event: .debug)
//        webSocket.sendRequestWith(method: method, parameters: parameters, completion: { (result, error) in
//            guard error == nil else {
//                Logger.log(message: "\(error!.localizedDescription)", event: .error)
//                completion([], error!)
//                return
//            }
//            
//            guard let postsDictinary = result as? [[String: Any]] else {
//                return
//            }
//            
//            let posts = postsDictinary.compactMap({ postDictionary -> PostModel? in
//                PostModel(postDictionary: postDictionary)
//            })
//            
//            completion(posts, nil)
//        })
    }
    
    private func methodForPostsFeed(type: PostsFeedType) -> WebSocketMethod {
        Logger.log(message: "Success", event: .severe)

        switch type {
        case .hot:
            return WebSocketMethod.getDiscussionsActual
        
        case .new:
            return WebSocketMethod.getDiscussionsNew
        
        case .popular:
            return WebSocketMethod.getDiscussionsPopular
        
        case .promoted:
            return WebSocketMethod.getDiscussionsActual
        }
    }
}
