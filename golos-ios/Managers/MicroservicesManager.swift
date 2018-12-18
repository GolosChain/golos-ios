//
//  MicroservicesManager.swift
//  Golos
//
//  Created by msm72 on 12/18/18.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

class MicroservicesManager {
    // MARK: - Class Functions

    /// API 'getSecret'
    class func getSecretKey(completion: @escaping (String?, ErrorAPI?) -> Void) {
        if isNetworkAvailable {
            let microserviceMethodAPIType = MicroserviceMethodAPIType.getSecretKey()
            
            broadcast.executeGET(byMicroserviceMethodAPIType: microserviceMethodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIMicroserviceSecretResult).result else {
                                        completion(nil, ErrorAPI.requestFailed(message: "User followings are not found"))
                                        return
                                    }
                                    
                                    completion(result.secret, nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(nil, errorAPI)
            })
        }
            
            // Offline mode
        else {
            completion(nil, nil)
        }
    }
}
