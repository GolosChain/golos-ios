//
//  GolosBlockchainManager.swift
//  Golos
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

public var requestIDs               =   [Int]()
public typealias RequestAPIType     =   (id: Int, message: String, startTime: Date)
public typealias ResponseAPIType    =   (response: [[String: Any]]?, error: Error?)
public typealias RequestApiStore    =   (type: RequestAPIType, completion: (ResponseAPIType) -> Void)

public class GolosBlockchainManager {
    // MARK: - Properties

    
    // MARK: - Class Initialization
    private init() {}
    
    
    // MARK: - Class Functions
    /**
     Call any of `GET` API methods.
     
     - Parameter method: The name of used API method with needed parameters.
     - Parameter completion: A completion handler.
     - Returns: Return `RequestAPIType` tuple.

     */
    public static func prepareToFetchData(byMethod method: MethodApiType) -> RequestAPIType? {
        Logger.log(message: "Success", event: .severe)
        
        func generateUniqueId() -> Int {
            var generatedID = 0
            
            repeat {
                generatedID = Int(arc4random_uniform(1000))
            } while requestIDs.contains(generatedID)
            
            requestIDs.append(generatedID)
            
            return generatedID
        }
        
        let codeID              =   generateUniqueId()
        let requestParamsType   =   method.introduced()
        
        let requestAPI          =   RequestAPI(id:          codeID,
                                               method:      "call",
                                               jsonrpc:     "2.0",
                                               params:      requestParamsType.paramsFirst)
        
        let requestParams       =   requestParamsType.paramsSecond

        do {
            // Encode data
            let jsonEncoder     =   JSONEncoder()
            var jsonData        =   try jsonEncoder.encode(requestParams)
            let jsonString2     =   "[\(String(data: jsonData, encoding: .utf8)!)]"
            
            jsonData            =   try jsonEncoder.encode(requestAPI)
            let jsonString      =   String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "]}", with: ",\(jsonString2)]}")
            
            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
            return (id: codeID, message: jsonString, startTime: Date())
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return nil
        }
    }
    
    /**
     Generating a unique ID.
     
     - Returns: A **Int** as unique ID.
     
     */
//    private static func generateUniqueId() -> Int {
//        var generatedID = 0
//
//        repeat {
//            generatedID = Int(arc4random_uniform(1000))
//        } while requestIDs.contains(generatedID)
//
//        requestIDs.append(generatedID)
//
//        return generatedID
//    }
}
