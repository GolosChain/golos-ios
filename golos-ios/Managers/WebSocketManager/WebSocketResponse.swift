//
//  WebSocketResponse.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct WebSocketResponse {
    let requestId: Int
    let result: Any?
    let error: NSError?
}

extension WebSocketResponse {
    init?(responseText: String) {
        guard let json = responseText.toDictionary() else {
            return nil
        }
        
        guard let requestId = json["id"] as? Int else {
            return nil
        }
        
        self.requestId = requestId
        
        var result: Any?
        var error: NSError?
        
        if let errorDictionary = json["error"] as? [String: Any] {
            let code = errorDictionary["code"] as! Int
            let message = errorDictionary["message"] as! String
            error = NSError(domain: "io.golos.websocket",
                            code: code,
                            userInfo: [NSLocalizedDescriptionKey: message])
        } else if let res = json["result"] {
            result = res
        } else {
            error = NSError(domain: "io.golos.websocket",
                                code: 666,
                                userInfo: [NSLocalizedDescriptionKey: "Unknown error g"])
        }
        
        self.error = error
        self.result = result
    }
}
