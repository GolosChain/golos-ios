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
     
     - Parameter userNames: User name.
     - Parameter completion: Contains two values:
     - Parameter displayedUsers: Array of `DisplayedUser`.
     - Parameter errorAPI: Type `ErrorAPI`.

    */
    func loadUsers(byNames userNames: [String], completion: @escaping (_ displayedUsers: [DisplayedUser]?, _ errorAPI: ErrorAPI?) -> Void) {
        Logger.log(message: "Success", event: .severe)

        // API 'get_accounts'
//        let requestAPIType = broadcast.prepareGET(requestByMethodType: MethodAPIType.getAccounts(names: userNames))!
//        // GolosBlockchainManager.prepareGET(requestByMethodType: MethodAPIType.getAccounts(names: userNames))!
//        Logger.log(message: "\nrequestAPIType =\n\t\(requestAPIType)", event: .debug)
//
//        // Network Layer (WebSocketManager)
//        DispatchQueue.main.async {
//            webSocketManager.sendRequest(withType: requestAPIType) { (responseAPIType) in
//                Logger.log(message: "\nresponseAPIType:\n\t\(responseAPIType)", event: .debug)
//                
//                guard let responseAPI = responseAPIType.responseAPI, let responseAPIResult = responseAPI as? ResponseAPIUserResult else {
//                    completion(nil, responseAPIType.errorAPI)
//                    return
//                }
//                
//                let displayedUsers = responseAPIResult.result.compactMap({ DisplayedUser(fromResponseAPIUser: $0) })
//                
//                // Return to files: `UserPresenter.swift`, `PostsFeedPresenter.swift`
//                completion(displayedUsers, nil)
//            }
//        }
    }
}
