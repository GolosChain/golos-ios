//
//  Broadcast.swift
//  GoloSwift
//
//  Created by msm72 on 15.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

/// Array of request unique IDs
public var requestIDs                       =   [Int]()

/// Type of request API
public typealias RequestMethodAPIType       =   (id: Int, requestMessage: String?, startTime: Date, methodAPIType: MethodAPIType, errorAPI: ErrorAPI?)
public typealias RequestOperationAPIType    =   (id: Int, requestMessage: String?, startTime: Date, operationAPIType: OperationAPIType, errorAPI: ErrorAPI?)

/// Type of response API
public typealias ResponseAPIType            =   (responseAPI: Decodable?, errorAPI: ErrorAPI?)
public typealias ResultAPIHandler           =   (Decodable) -> Void
public typealias ErrorAPIHandler            =   (ErrorAPI) -> Void

/// Type of stored request API
public typealias RequestMethodAPIStore      =   (methodAPIType: RequestMethodAPIType, completion: (ResponseAPIType) -> Void)
public typealias RequestOperationAPIStore   =   (operationAPIType: RequestOperationAPIType, completion: (ResponseAPIType) -> Void)


public class Broadcast {
    // MARK: - Properties
    public static let shared                =   Broadcast()
    
    
    // MARK: - Class Initialization
    private init() {
        let config = (Bundle.main.infoDictionary?["Config"] as? String)?.replacingOccurrences(of: "\\", with: "")
        
        if let name = config {
            switch name.uppercased() {
            case "DEBUG":
                appBuildConfig      =   .Debug
                
            case "DEVELOPMENT":
                appBuildConfig      =   .Development
                
            case "RELEASE":
                appBuildConfig      =   .Release
                
            default:
                appBuildConfig      =   .Debug
            }
        }
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    /// Completion handler
    func completion<Result>(onResult: @escaping (Result) -> Void, onError: @escaping (ErrorAPI) -> Void) -> ((Result?, ErrorAPI?) -> Void) {
        return { (maybeResult, maybeError) in
            if let result = maybeResult {
                onResult(result)
            }
            
            else if let error = maybeError {
                onError(error)
            }
            
            else {
                onError(ErrorAPI.requestFailed(message: "Result not found"))
            }
        }
    }
    
    /**
     Execute any of `GET` API methods.
     
     - Parameter methodAPIType: Type of API method.
     - Parameter completion: Blockchain response.

     */
    public func executeGET(byMethodAPIType methodAPIType: MethodAPIType, onResult: @escaping (Decodable) -> Void, onError: @escaping (ErrorAPI) -> Void) {
        // Create GET Request messages to Blockchain
        let requestAPIType = self.prepareGET(requestByMethodAPIType: methodAPIType)
        
        guard let requestMessage = requestAPIType.requestMessage else {
            onError(ErrorAPI.requestFailed(message: "GET Request Failed"))
            return
        }
        
        Logger.log(message: "\nrequestAPIType:\n\t\(requestMessage)\n", event: .debug)
        
        // Send GET Request messages to Blockchain
        webSocketManager.sendGETRequest(withMethodAPIType: requestAPIType, completion: { responseAPIType in
            if let responseAPI = responseAPIType.responseAPI {
                onResult(responseAPI)
            }
            
            else {
                onError(ErrorAPI.responseUnsuccessful(message: "Result not found"))
            }
        })
    }
    
    
    /// Prepare GET API request
    private func prepareGET(requestByMethodAPIType methodAPIType: MethodAPIType) -> RequestMethodAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   methodAPIType.introduced()
        
        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        let requestParams           =   requestParamsType.paramsSecond
        
        do {
            // Encode data
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   Data()

            switch methodAPIType {
            case .getAccounts(_):
                jsonData            =   try jsonEncoder.encode(requestParams as? [String])

            case .getDiscussions(_):
                jsonData            =   try jsonEncoder.encode(requestParams as? RequestParameterAPI.Discussion)

            case .getUserReplies(_), .getUserFollowCounts(_):
                jsonData            =   Data((requestParams as! String).utf8)

            case .getAllContentReplies(_):
                jsonData            =   Data((requestParams as! String).utf8)

            default:
                break
            }

            let jsonParamsString    =   "[\(String(data: jsonData, encoding: .utf8)!)]"
            
            jsonData                =   try jsonEncoder.encode(requestAPI)
            var jsonString          =   String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "]}", with: ",\(jsonParamsString)]}")
            jsonString              =   jsonString
                                            .replacingOccurrences(of: "[[[", with: "[[")
                                            .replacingOccurrences(of: "[\"nil\"]", with: "]")
            
            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
            return (id: codeID, requestMessage: jsonString, startTime: Date(), methodAPIType: requestParamsType.methodAPIType, errorAPI: nil)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return (id: codeID, requestMessage: nil, startTime: Date(), methodAPIType: requestParamsType.methodAPIType, errorAPI: ErrorAPI.requestFailed(message: "GET Request Failed"))
        }
    }
    
    
    /**
     Execute any of `POST` API methods.
     
     - Parameter operationAPIType: Type of operation.
     - Parameter completion: Blockchain response.
     
     */
    public func executePOST(requestByOperationAPIType operationAPIType: OperationAPIType, userName: String, onResult: @escaping (Decodable) -> Void, onError: @escaping (ErrorAPI) -> Void) {
        // API `get_dynamic_global_properties`
        self.getDynamicGlobalProperties(completion: { success in
            guard success else {
                onError(ErrorAPI.requestFailed(message: "Dynamic Global Properties Error"))
                return
            }
            
            // Create Operations for Transaction (tx)
            let operations: [Encodable]   =   operationAPIType.introduced().paramsSecond
            Logger.log(message: "\nexecutePOST - operations:\n\t\(operations)\n", event: .debug)
            
            // Create Transaction (tx)
            var tx: Transaction = Transaction(withOperations: operations)
            tx.setUser(name: userName)
            Logger.log(message: "\nexecutePOST - transaction:\n\t\(tx)\n", event: .debug)
            
            // Transaction (tx): serialize & SHA256 & ECC signing
            let errorAPI = tx.serialize(byOperationAPIType: operationAPIType)
            
            guard errorAPI == nil else {
                // Show alert error
                Logger.log(message: "\(errorAPI!.localizedDescription)", event: .error)
                onError(errorAPI!)
                return
            }
            
            // Create POST message
            let requestOperationAPIType = self.preparePOST(requestByOperationAPIType: operationAPIType, byTransaction: tx)
            Logger.log(message: "\nexecutePOST - requestOperationAPIType:\n\t\(requestOperationAPIType.requestMessage!)\n", event: .debug)
            
            guard requestOperationAPIType.errorAPI == nil else {
                onError(ErrorAPI.requestFailed(message: "POST Request Failed"))
                return
            }
            
            // Send POST Request messages to Blockchain
            webSocketManager.sendPOSTRequest(withOperationAPIType: requestOperationAPIType, completion: { responseAPIType in
                if let responseAPI = responseAPIType.responseAPI {
                    onResult(responseAPI)
                }
                    
                else {
                    onError(ErrorAPI.responseUnsuccessful(message: "Result not found"))
                }
            })
        })
    }
    
    
    /// Prepare POST Request API
    private func preparePOST(requestByOperationAPIType operationAPIType: OperationAPIType, byTransaction transaction: Transaction) -> RequestOperationAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   operationAPIType.introduced()

        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        do {
            // Encode: requestAPI + transaction
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   try jsonEncoder.encode(requestAPI)
            let jsonAPIString       =   "\(String(data: jsonData, encoding: .utf8)!)"
                                            .replacingOccurrences(of: "]}", with: ",")
            
            var jsonChainString     =   jsonAPIString
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // ref_block_num
            jsonData                =   try jsonEncoder.encode(["ref_block_num": transaction.ref_block_num])
            var jsonTxString        =   "[\(String(data: jsonData, encoding: .utf8)!)]"
                                            .replacingOccurrences(of: "}]", with: ",")
            
            jsonChainString         +=  jsonTxString
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // ref_block_prefix
            jsonData                =   try jsonEncoder.encode(["ref_block_prefix": transaction.ref_block_prefix])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                                            .replacingOccurrences(of: "{", with: "")
                                            .replacingOccurrences(of: "}", with: ",")
            
            jsonChainString         +=  jsonTxString
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // expiration
            jsonData                =   try jsonEncoder.encode(["expiration": transaction.expiration])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                                            .replacingOccurrences(of: "{", with: "")
                                            .replacingOccurrences(of: "}", with: ",")
            
            jsonChainString         +=  jsonTxString
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // extensions
            jsonData                =   try jsonEncoder.encode(["extensions": transaction.extensions ?? [String]()])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                                            .replacingOccurrences(of: "{", with: "")
                                            .replacingOccurrences(of: "}", with: ",")
            
            jsonChainString         +=  jsonTxString
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // signatures
            jsonData                =   try jsonEncoder.encode(["signatures": transaction.signatures])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                                            .replacingOccurrences(of: "{", with: "")
                                            .replacingOccurrences(of: "}", with: ",\"operations\":[[")
            
            jsonChainString         +=  jsonTxString
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
           
            // Operations
            for operation in transaction.operations {
                jsonChainString     +=   (RequestParameterAPI.decodeToString(model: operation as! RequestParameterAPIPropertiesSupport) ?? "xxx") + "}]]}"
                Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            }
            
            return (id: codeID, requestMessage: jsonChainString, startTime: Date(), operationAPIType: requestParamsType.operationAPIType, errorAPI: nil)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return (id: codeID, requestMessage: nil, startTime: Date(), operationAPIType: requestParamsType.operationAPIType, errorAPI: ErrorAPI.requestFailed(message: "Request Failed"))
        }
    }
    
    
    /// API `get_dynamic_global_properties`
    private func getDynamicGlobalProperties(completion: @escaping (Bool) -> Void) {
       let requestMethodAPIType  =   self.prepareGET(requestByMethodAPIType: .getDynamicGlobalProperties())
        Logger.log(message: "\nrequestAPIType =\n\t\(requestMethodAPIType)", event: .debug)

        // Network Layer (WebSocketManager)
        DispatchQueue.main.async {
            webSocketManager.sendGETRequest(withMethodAPIType: requestMethodAPIType, completion: { responseAPIType in
                Logger.log(message: "\nresponseAPIType:\n\t\(responseAPIType)", event: .debug)
                
                guard let responseAPI = responseAPIType.responseAPI,
                    let responseAPIResult   =   responseAPI as? ResponseAPIDynamicGlobalPropertiesResult,
                    let globalProperties    =   responseAPIResult.result else {
                    
                    Logger.log(message: responseAPIType.errorAPI!.caseInfo.message, event: .error)
                        completion(false)
                        return
                }
                
                Logger.log(message: "\nglobalProperties:\n\t\(globalProperties)", event: .debug)
                
                time                =   globalProperties.time.convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
                headBlockID         =   globalProperties.head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
                headBlockNumber     =   UInt16(globalProperties.head_block_number & 0xFFFF)
                
                completion(true)
            })
        }
    }


    /// Generating a unique ID
    private func generateUniqueId() -> Int {
        var generatedID = 0
        
        repeat {
            generatedID = Int(arc4random_uniform(1000))
        } while requestIDs.contains(generatedID)
        
        requestIDs.append(generatedID)
        
        return generatedID
    }
}
