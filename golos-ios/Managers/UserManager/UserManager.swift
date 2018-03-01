//
//  UserManager.swift
//  Golos
//
//  Created by Grigory on 19/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class UserManager {
    let webSocket = WebSocketManager.shared
    
    func loadUsers(_ userNames: [String], completion: @escaping ([UserModel], NSError?) -> Void) {
        let method = methodForUserRequest(.getUsers)
        let parameters = [userNames]
        
        webSocket.sendRequestWith(method: method, parameters: parameters) { result, error in
            guard error == nil else {
                completion([], error!)
                return
            }
            
            guard let userArray = result as? [[String: Any]] else {
                return
            }
            
            let users = userArray.flatMap({ userDictionary -> UserModel? in
                UserModel(userDictionary: userDictionary)
            })

            completion(users, nil)
        }
    }
    
    func loadUser(with name: String, completion: @escaping (UserModel?, NSError?) -> Void) {
        loadUsers([name]) { users, error in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            let user = users.first
            
            completion(user, error)
        }
    }

    private func methodForUserRequest(_ request: UserRequestType) -> WebSocketMethod {
        switch request {
        case .getUsers: return WebSocketMethod.getAccounts
        }
    }
}
