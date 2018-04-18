//
//  UserManager.swift
//  Golos
//
//  Created by Grigory on 19/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class UserManager {
    // MARK: - Custom Functions
    /**
     Load Users profiles by names.
     
     - Parameter userNames: User name.
     - Parameter completion: Return two values:
     - Parameter users: Array of users.
     - Parameter errorAPI: ErrorAPI.

    */
    func loadUsers(byNames userNames: [String], completion: @escaping (_ users: [UserModel]?, _ errorAPI: ErrorAPI?) -> Void) {
        Logger.log(message: "Success", event: .severe)

        let requestAPIType = GolosBlockchainManager.fetchData(byMethod: MethodAPIType.getAccounts(names: userNames))!
        Logger.log(message: "requestAPIType = \(requestAPIType)", event: .debug)

        // API
        DispatchQueue.main.async {
            webSocketManager.sendRequest(withType: requestAPIType) { (responseAPIType) in
                Logger.log(message: "responseAPIType: \(responseAPIType)", event: .debug)
                
                guard let responseAPI = responseAPIType.responseAPI, let responseAPIResult = responseAPI as? ResponseAPIFeedResult else {
                    completion(nil, responseAPIType.errorAPI)
                    return
                }
                
                let displayedPosts = responseAPIResult.result.compactMap({ DisplayedPost(fromPostsFeed: $0) })
                
//                completion(displayedPosts, nil)
            }
        }
    }
        // DELETE
//        let method = methodForUserRequest(.getUsers)
//        let parameters = [userNames]

//        webSocket.sendRequestWith(method: method, parameters: parameters) { result, error in
//            guard error == nil else {
//                Logger.log(message: "\(error!.localizedDescription)", event: .error)
//                completion([], error!)
//                return
//            }
//            
//            guard let userArray = result as? [[String: Any]] else {
//                return
//            }
//            
//            let users = userArray.compactMap({ userDictionary -> UserModel? in
//                UserModel(userDictionary: userDictionary)
//            })
//
//            completion(users, nil)
//        }
//    }
    
    
    // DELETE
//    func loadUser(with name: String, completion: @escaping (_ user: UserModel?, _ errorAPI: Error?) -> Void) {
//        self.loadUsers(byNames: [name]) { (users, errorAPI) in
//            guard errorAPI == nil else {
//                Logger.log(message: "\(error!.localizedDescription)", event: .error)
//                completion(nil, error!)
//                return
//            }
//
//            let user = users!.first
//
//            completion(user, error)
//        }
//    }

    private func methodForUserRequest(_ request: UserRequestType) -> WebSocketMethod {
        switch request {
        case .getUsers:
            return WebSocketMethod.getAccounts
        }
    }
}
