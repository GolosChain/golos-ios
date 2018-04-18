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
    /**
     This method load posts by Feed type.
     
     - Parameter type: The case value of Feed type.
     - Parameter limit: The limit value.
     - Parameter completion: Contains two values:
     - Parameter displayedPosts: Array of `DisplayedPost`.
     - Parameter errorAPI: Type `ErrorAPI`.

     */
    func loadPostsFeed(withType type: PostsFeedType, andLimit limit: Int, completion: @escaping ((_ displayedPosts: [DisplayedPost]?, _ errorAPI: ErrorAPI?) -> Void)) {
        Logger.log(message: "Success", event: .severe)
        
        let requestAPIType = GolosBlockchainManager.fetchData(byMethod: self.methodForPostsFeed(fotType: type, andLimit: limit))!
        Logger.log(message: "requestAPIType = \(requestAPIType)", event: .debug)
        
        // API 'get_discussions_by_' 4 types
        DispatchQueue.main.async {
            webSocketManager.sendRequest(withType: requestAPIType) { (responseAPIType) in
//                Logger.log(message: "responseAPIType: \(responseAPIType)", event: .debug)
                
                guard let responseAPI = responseAPIType.responseAPI, let responseAPIResult = responseAPI as? ResponseAPIFeedResult else {
                    completion(nil, responseAPIType.errorAPI)
                    return
                }
                
                let displayedPosts = responseAPIResult.result.compactMap({ DisplayedPost(fromResponseAPIFeed: $0) })
                
                // Return to file `PostsFeedPresenter.swift`
                completion(displayedPosts, nil)
            }
        }
    }

    /**
     This method prepare API method by type.
     
     - Parameter type: The case value of discussion type.
     - Parameter limit: The limit value.
     - Returns: Return `MethodApiType` case value of enum.
     
    */
    private func methodForPostsFeed(fotType type: PostsFeedType, andLimit limit: Int) -> MethodAPIType {
        Logger.log(message: "Success", event: .severe)
        
        switch type {
        /// Hot (actual) discussions.
        case .actual:
            return MethodAPIType.getDiscussionsByHot(limit: limit)

        /// New discussions.
        case .new:
            return MethodAPIType.getDiscussionsByCreated(limit: limit)

        /// Popular discussions.
        case .popular:
            return MethodAPIType.getDiscussionsByTrending(limit: limit)

        /// Promoted discussions.
        case .promoted:
            return MethodAPIType.getDiscussionsByPromoted(limit: limit)
        }
    }
}
