//
//  GolosBlockchainManager.swift
//  Golos
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

/// Array of request unique IDs
public var requestIDs               =   [Int]()
/// Type of request API
public typealias RequestAPIType     =   (id: Int, requestMessage: String, startTime: Date, methodAPIType: MethodAPIType)
/// Type of response API
public typealias ResponseAPIType    =   (responseAPI: Decodable?, errorAPI: ErrorAPI?)
/// Type of stored request API
public typealias RequestAPIStore    =   (type: RequestAPIType, completion: (ResponseAPIType) -> Void)

public class GolosBlockchainManager {
    // MARK: - Class Initialization
    private init() {}
    
    
    // MARK: - Class Functions
    /**
     Call any of `GET` API methods.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return `RequestAPIType` tuple.

     */
    public static func fetchData(byMethod method: MethodAPIType) -> RequestAPIType? {
        Logger.log(message: "Success", event: .severe)
        
        /**
         Generating a unique ID.
         
         - Returns: A `Int` as unique ID.
         
         */
        func generateUniqueId() -> Int {
            var generatedID = 0
            
            repeat {
                generatedID = Int(arc4random_uniform(1000))
            } while requestIDs.contains(generatedID)
            
            requestIDs.append(generatedID)
            
            return generatedID
        }
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   method.introduced()
        
        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        let requestParams           =   requestParamsType.paramsSecond

        do {
            // Encode data
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   try jsonEncoder.encode(requestParams)
            let jsonParamsString    =   "[\(String(data: jsonData, encoding: .utf8)!)]"
            
            jsonData                =   try jsonEncoder.encode(requestAPI)
            var jsonString          =   String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "]}", with: ",\(jsonParamsString)]}")
            jsonString              =   jsonString.replacingOccurrences(of: "[[[", with: "[[").replacingOccurrences(of: "]]]", with: "]]")
            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
            return (id: codeID, requestMessage: jsonString, startTime: Date(), methodAPIType: requestParamsType.methodAPIType)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return nil
        }
    }
}
