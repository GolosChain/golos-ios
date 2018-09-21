//
//  Validator.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

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
     Checks `JSON` for an error.
     
     - Parameter json: Input response dictionary.
     - Parameter completion: Return two values:
     - Parameter codeID: Request ID.
     - Parameter hasError: Error indicator.

     */
    class func validate(json: [String: Any], completion: @escaping (_ codeID: Int, _ hasError: Bool) -> Void) {
//        Logger.log(message: json.description, event: .debug)
        completion(json["id"] as! Int, json["error"] != nil)
    }
}
