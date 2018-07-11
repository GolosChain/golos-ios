//
//  ReusableCell.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

protocol ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath)
}

protocol LoadUserProtocol {
    func loadUserInfo(byName name: String, completion: @escaping (User?, ErrorAPI?) -> Void)
}


// MARK: - Default implementation of ReusableCell protocol
extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


// MARK: - Default implementation of LoadUserProtocol protocol
extension LoadUserProtocol {
    func loadUserInfo(byName name: String, completion: @escaping (User?, ErrorAPI?) -> Void) {
        // API 'get_accounts'
        if isNetworkAvailable {
            // Create MethodAPIType
            let methodAPIType   =   MethodAPIType.getAccounts(names: RequestParameterAPI.User(names: [name]))
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let userResult = (responseAPIResult as! ResponseAPIUserResult).result, userResult.count > 0 else {
                                        completion(nil, ErrorAPI.requestFailed(message: "User is not found"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entity
                                    if let userResponseAPI = userResult.first {
                                        let userEntity              =   User.instance(byUserID: userResponseAPI.id)
                                        userEntity.isAuthorized     =   true
                                        userEntity.updateEntity(fromResponseAPI: userResponseAPI)
                                        
                                        // Send User info
                                        completion(User.instance(byUserID: userResponseAPI.id), nil)
                                    }
                },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    
                                    // Send error
                                    completion(nil, errorAPI)
            })
        }
            
        // Offline mode
        else {
            // Send User info
            guard let user = CoreDataManager.instance.readEntity(withName: name, andPredicateParameters: nil) as? User else {
                completion(nil, ErrorAPI.requestFailed(message: "User is not found"))
                return
            }
            
            completion(user, nil)
        }
    }
}
