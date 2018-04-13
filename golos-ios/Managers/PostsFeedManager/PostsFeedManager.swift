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
    func loadFeed(withType type: PostsFeedType, andLimit limit: Int, completion: @escaping ([PostModel], NSError?) -> Void) {
        Logger.log(message: "Success", event: .severe)
        
        let requestAPIType = GolosBlockchainManager.prepareToFetchData(byMethod: self.methodForPostsFeed(fotType: type, andLimit: limit))!
        Logger.log(message: "requestAPIType = \(requestAPIType)", event: .debug)
        
        // API
        DispatchQueue.main.async {
            webSocketManager.sendRequest(withType: requestAPIType) { (responseAPIType) in
                Logger.log(message: "responseAPIType: \(responseAPIType)", event: .debug)
                
                guard responseAPIType.error == nil else {
                    Logger.log(message: "\(responseAPIType.error!.localizedDescription)", event: .error)
                    completion([], responseAPIType.error! as NSError)
                    return
                }
                
                guard let postsDictinary = responseAPIType.response else {
                    return
                }
                
                let posts = postsDictinary.compactMap({ postDictionary -> PostModel? in
                    PostModel(postDictionary: postDictionary)
                })
                
                completion(posts, nil)
            }
        }

        
        // DELETE
//        let method = methodForPostsFeed(type: type)
//        let parameters = ["limit": amount]

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

    /**
     This method prepare API method by type.
     
     - Parameter type: The case value of discussion type.
     - Parameter limit: The limit value.
     - Returns: Return `MethodApiType` case value of enum.
     
    */
    private func methodForPostsFeed(fotType type: PostsFeedType, andLimit limit: Int) -> MethodApiType {
        Logger.log(message: "Success", event: .severe)
        
        switch type {
        /// Hot (actual) discussions.
        case .actual:
            return MethodApiType.getDiscussionsByHot(limit: limit)
            
        /// New discussions.
        case .new:
            return MethodApiType.getDiscussionsByCreated(limit: limit)

        /// Popular discussions.
        case .popular:
            return MethodApiType.getDiscussionsByTrending(limit: limit)

        /// Promoted discussions.
        case .promoted:
            return MethodApiType.getDiscussionsByPromoted(limit: limit)
        }
    }
}
