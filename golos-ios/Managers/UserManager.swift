//
//  UserManager.swift
//  Golos
//
//  Created by Grigory on 19/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

class UserManager {
    // MARK: - Custom Functions
    /**
     Load Users profiles by names.
     
     - Parameter names: Array of `User` names.
     - Parameter completion: Contains two values:
     - Parameter displayedUsers: Array of `DisplayedUser`.
     - Parameter errorAPI: Type `ErrorAPI`.

    */
    // FIXME: - ADD LOAD USERS AVATARS
    func loadUsers(byNames names: [String], completion: @escaping (_ displayedUsers: [DisplayedUser]?, _ errorAPI: ErrorAPI?) -> Void) {
        Logger.log(message: "Success", event: .severe)
        
        // Create MethodAPIType
        let methodAPIType = MethodAPIType.getAccounts(names: RequestParameterAPI.User(names: names))
        
        // API 'get_accounts'
        broadcast.executeGET(byMethodAPIType: methodAPIType,
                             onResult: { responseAPIResult in
                                Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                
                                guard let result = (responseAPIResult as! ResponseAPIUserResult).result, result.count > 0 else {
                                    completion([], nil)
                                    return
                                }
                                
                                let displayedUsers = result.compactMap({ DisplayedUser(fromResponseAPIUser: $0) })
                                completion(displayedUsers, nil)
        },
                             onError: { errorAPI in
                                Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                completion(nil, errorAPI)
        })
    }
}
