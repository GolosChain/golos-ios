//
//  WebSocketResponse.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct WebSocketResponse {
    // MARK: - Properties
    let requestId: Int
    var result: Any?
    var error: NSError?


    // MARK: - Structure Initialization
    init?(withText text: String) {
        Logger.log(message: "Success", event: .severe)

        guard let json = text.toDictionary() else {
            return nil
        }
        
        guard let requestId = json["id"] as? Int else {
            return nil
        }
        
        self.requestId = requestId
        
        if let errorDictionary = json["error"] as? [String: Any], let code = errorDictionary["code"] as? Int, let message = errorDictionary["message"] as? String {
            self.error = NSError(domain:    "io.golos.websocket",
                                 code:      code,
                                 userInfo:  [NSLocalizedDescriptionKey: message])
        }
            
        else if let res = json["result"] {
            self.result = res
        }
            
        else {
            self.error = NSError(domain:    "io.golos.websocket",
                                 code:      666,
                                 userInfo:  [NSLocalizedDescriptionKey: "Unknown error golos.io"])
        }
    }
}
