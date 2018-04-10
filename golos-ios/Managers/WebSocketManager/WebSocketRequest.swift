//
//  WebSocketRequest.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct WebSocketRequest {
    let requestId: Int
    let method: WebSocketMethod
    let parameters: Any
    let completion: (Any?, NSError?) -> Void
    
    var messageString: String {
        var parametersString = ""
        
        if let dictionary = parameters as? [String: Any] {
            for (key, parameter) in dictionary {
                let parameterString = (parameter is String) ? "\"\(parameter)\"" : "\(parameter)"
                let keyParameterString = "\"\(key)\":\(parameterString)"
                parametersString.append(keyParameterString)
            }
            parametersString = "[{\(parametersString)}]"
        }
        
        else if let array = parameters as? [Any] {
            for (index, parameter) in array.enumerated() {
                var str = (parameter is String) ? "\"\(parameter)\"" : "\(parameter)"
                if index != 0 { str = "," + str}
                parametersString.append(str)
            }
           
            parametersString = "[\(parametersString)]"
        }
        
        let resultString = "{\"method\":\"\(method.rawValue)\", \"params\":\(parametersString), \"id\":\(requestId)}"
        
        return resultString
    }
}
