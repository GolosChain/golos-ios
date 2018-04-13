//
//  Validator.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class Validator {
    // MARK: - Custom Functions
    class func validate(login: String?) -> Bool {
        Logger.log(message: "Success", event: .severe)

        guard let login = login, login.count > 0 else {
            return false
        }

        return true
    }
    
    class func validate(key: String?) -> Bool {
        Logger.log(message: "Success", event: .severe)
        
        guard let key = key, key.count > 0 else {
            return false
        }
        
        return true
    }
    
    /**
 
    */
    class func validate(json: [String: Any], completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        if let jsonError = json["error"] as? [String: Any], let errorCode = jsonError["code"] as? Int, let errorMessage = jsonError["message"] as? String {
            let error = NSError(domain:    "io.golos.websocket",
                            code:      errorCode,
                            userInfo:  [NSLocalizedDescriptionKey: errorMessage])
        }
        
    }
}
