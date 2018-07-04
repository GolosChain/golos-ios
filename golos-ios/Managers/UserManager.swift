//
//  UserManager.swift
//  Golos
//
//  Created by Grigory on 19/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

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
        if isNetworkAvailable {
            // Create MethodAPIType
            let methodAPIType = MethodAPIType.getAccounts(names: RequestParameterAPI.User(names: names))
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let usersResult = (responseAPIResult as! ResponseAPIUserResult).result, usersResult.count > 0 else {
                                        // Send empty Users info
                                        completion([], nil)
                                        return
                                    }
                                    
                                    // Update Users entities
                                    usersResult.forEach({
                                        let userEntity = User.instance(byUserID: $0.id )
                                        
                                        if usersResult.count == 1 {
                                            userEntity.isAuthorized = true
                                        }
                                        
                                        userEntity.updateEntity(fromResponseAPI: $0)
                                    })
                                    
                                    // Send Users info
                                    var displayedUsers = usersResult.compactMap({ DisplayedUser(fromResponseAPIUser: $0) })
                                    
                                    if displayedUsers.count == 1 {
                                        displayedUsers[0].isAuthorized = true
                                    }
                                    
                                    completion(displayedUsers, nil)
                },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    
                                    // Send error
                                    completion(nil, errorAPI)
            })
        }
            
        // CoreData
        else {
            // Send Users info
            var displayedUsers: [DisplayedUser] = [DisplayedUser]()
            
            if let user = User.current, names.count == 1 {
                displayedUsers.append(DisplayedUser(fromUser: user))
            }
            
            else if names.count > 1 {
                if let usersEntities = CoreDataManager.instance.readEntities(withName:                  "User",
                                                                             withPredicateParameters:   nil,
                                                                             andSortDescriptor:         nil) as? [User] {
                    displayedUsers = usersEntities.compactMap({ DisplayedUser(fromUser: $0) })
                }
            }
            
            completion(displayedUsers, nil)
        }
    }
}
