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
    let parameters: [String: Any]
    let completion: (Any?, NSError?) -> Void
    
    var messageString: String {
        var parametersString = ""
        for (key, parameter) in parameters {
            let parameterString = (parameter is String) ? "\"\(parameter)\"" : "\(parameter)"
            let keyParameterString = "\"\(key)\":\(parameterString)"
            parametersString.append(keyParameterString)
        }
        
        parametersString = "[{\(parametersString)}]"
        
        let resultString = "{\"method\":\"\(method.rawValue)\", \"params\":\(parametersString), \"id\":\(requestId)}"
        return resultString
        
//        "{\"method\":\"\(type.rawValue)\", \"params\": [{\"limit\":\(limit)}], \"id\":14}"
    }
}
