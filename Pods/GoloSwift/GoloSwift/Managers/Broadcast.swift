//
//  Broadcast.swift
//  GoloSwift
//
//  Created by msm72 on 15.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

/// Array of request unique IDs
public var requestIDs               =   [Int]()

/// Type of request API
public typealias RequestAPIType     =   (id: Int, requestMessage: String?, startTime: Date, methodAPIType: MethodAPIType, errorAPI: ErrorAPI?)

/// Type of response API
public typealias ResponseAPIType    =   (responseAPI: Decodable?, errorAPI: ErrorAPI?)
public typealias ResultAPIHandler   =   (Decodable) -> Void
public typealias ErrorAPIHandler    =   (ErrorAPI) -> Void

/// Type of stored request API
public typealias RequestAPIStore    =   (type: RequestAPIType, completion: (ResponseAPIType) -> Void)


public class Broadcast {
    // MARK: - Properties
    public static let shared        =   Broadcast()
    
    
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
        // Create GET message to blockchain
        let requestAPIType = self.prepareGET(requestByMethodType: methodAPIType)
        
        guard let requestMessage = requestAPIType.requestMessage else {
            onError(ErrorAPI.requestFailed(message: "GET Request Failed"))
            return
        }
        
        Logger.log(message: "\nrequestAPIType:\n\t\(requestMessage)\n", event: .debug)
        
        // Send GET message to blockchain
        webSocketManager.sendRequest(withType: requestAPIType, completion: { responseAPIType in
            if let responseAPI = responseAPIType.responseAPI {
                onResult(responseAPI)
            }
            
            else {
                onError(ErrorAPI.responseUnsuccessful(message: "Result not found"))
            }
        })
    }
    
    
    /// Prepare GET API request
    private func prepareGET(requestByMethodType methodType: MethodAPIType) -> RequestAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   methodType.introduced()
        
        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        let requestParams           =   requestParamsType.paramsSecond
        
        do {
            // Encode data
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   Data()

            switch methodType {
            case .getAccounts(_):
                jsonData            =   try jsonEncoder.encode(requestParams as? [String])
                
            case .getDiscussions(_):
                jsonData            =   try jsonEncoder.encode(requestParams as? RequestParameterAPI.Discussion)

            case .getUserReplies(_):
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
//                                            .replacingOccurrences(of: "]]]", with: "]]")
                                            .replacingOccurrences(of: "[\"nil\"]", with: "]")
//                                            .replacingOccurrences(of: "{\"names\":", with: "")      // getAccounts
//                                            .replacingOccurrences(of: "]}]]", with: "]]]")          // getAccounts
            
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
    public func executePOST(byOperationAPIType operationAPIType: OperationAPIType, onResult: @escaping (Decodable) -> Void, onError: @escaping (ErrorAPI) -> Void) {
        // API `get_dynamic_global_properties`
        self.getDynamicGlobalProperties(completion: { success in
            guard success else {
                onError(ErrorAPI.requestFailed(message: "Dynamic Global Properties Error"))
                return
            }
            
            // Create Operation
            let operation: [Any] = operationAPIType.getFields()
            Logger.log(message: "\noperation:\n\t\(operation)\n", event: .debug)
            
            // Create Transaction
            var tx: Transaction = Transaction(withOperations: operation)
            Logger.log(message: "\ntransaction:\n\t\(tx)\n", event: .debug)
            
            // Transaction: serialize & SHA256 & ECC signing
            let errorAPI = tx.serialize(byOperationType: operationAPIType)
            
            guard errorAPI == nil else {
                // Show alert error
                Logger.log(message: "\(errorAPI!.localizedDescription)", event: .error)
                onError(errorAPI!)
                return
            }
            
            // Create POST message
            let requestAPIType = self.preparePOST(requestByMethodType: .verifyAuthorityVote, byTransaction: tx)
            Logger.log(message: "\nrequestAPIType:\n\t\(requestAPIType.requestMessage!)\n", event: .debug)
            
            guard requestAPIType.errorAPI == nil else {
                onError(ErrorAPI.requestFailed(message: "POST Request Failed"))
                return
            }
            
            // Send POST message to blockchain
            webSocketManager.sendRequest(withType: requestAPIType, completion: { responseAPIType in
                if let responseAPI = responseAPIType.responseAPI {
                    onResult(responseAPI)
                }
                    
                else {
                    onError(ErrorAPI.responseUnsuccessful(message: "Result not found"))
                }
            })
        })
    }
    
    
    /// Prepare POST API request
    private func preparePOST(requestByMethodType methodType: MethodAPIType, byTransaction transaction: Transaction) -> RequestAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   methodType.introduced()
        
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
            
            // operations
            if  let array = transaction.operations[0] as? [Any],
                let operationArray = array[2] as? [String: Any],
                let operationName = array[0] as? String,
                let operationTypeID = array[1] as? Int {
                // operation name
                jsonChainString     +=  "\"\(operationName)\",{"
                Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
                
                let keyNames = OperationAPIType.getFieldNames(byTypeID: operationTypeID)
                
                for (i, keyName) in keyNames.enumerated() {
                    let value       =   operationArray.first(where: { $0.key == keyName })!.value
                    
                    // Casting Type
                    if type(of: value) is String.Type {
                        jsonData    =   try jsonEncoder.encode(["\(keyName)": "\(value)"])
                    }
                        
                    else if type(of: value) is Int64.Type {
                        jsonData    =   try jsonEncoder.encode(["\(keyName)": value as! Int64])
                    }
                    
                    jsonTxString    =   "\(String(data: jsonData, encoding: .utf8)!)"
                        .replacingOccurrences(of: "{", with: "")
                    
                    jsonTxString    =   jsonTxString.replacingOccurrences(of: "}", with: (i == keyNames.count - 1) ? "}]]}]]}" : ",")
                    jsonChainString +=  jsonTxString
                    Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
                }
            }
            
            // Example of request message
            /*
                {"id":1,"method":"call","jsonrpc":"2.0","params":["database_api","verify_authority",
                    [{"ref_block_num":54254,"ref_block_prefix":2067645268,"expiration":"2018-05-14T15:25:30",
                    "operations":[["vote",{"voter":"msm72","author":"yuri-vlad-second","permlink":"sdgsdgsdg234234","weight":10000}]],"extensions":[],
                    "signatures":["1f0541ff3ca57f2d7b1bd7d6c9c5c7c1cbcebe16fd51840826f3670950b5ba90b0743edff772fb29fa8a40665bc19535658fd69831684a30384c0123c13da08be6"]
                    }]
                ]}
             */
            
            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            return (id: codeID, requestMessage: jsonChainString, startTime: Date(), methodAPIType: requestParamsType.methodAPIType, errorAPI: nil)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return (id: codeID, requestMessage: nil, startTime: Date(), methodAPIType: requestParamsType.methodAPIType, errorAPI: ErrorAPI.requestFailed(message: "Request Failed"))
        }
    }
    
    
    /// API `get_dynamic_global_properties`
    private func getDynamicGlobalProperties(completion: @escaping (Bool) -> Void) {
        // API `get_dynamic_global_properties`
        let requestAPIType = self.prepareGET(requestByMethodType: .getDynamicGlobalProperties())
        Logger.log(message: "\nrequestAPIType =\n\t\(requestAPIType)", event: .debug)
        
        // Network Layer (WebSocketManager)
        DispatchQueue.main.async {
            webSocketManager.sendRequest(withType: requestAPIType) { (responseAPIType) in
                Logger.log(message: "\nresponseAPIType:\n\t\(responseAPIType)", event: .debug)
                
                guard   let responseAPI = responseAPIType.responseAPI,
                    let responseAPIResult = responseAPI as? ResponseAPIDynamicGlobalPropertiesResult,
                    let globalProperties = responseAPIResult.result else {
                    Logger.log(message: responseAPIType.errorAPI!.caseInfo.message, event: .error)
                        completion(false)
                        return
                }
                
                Logger.log(message: "\nglobalProperties:\n\t\(globalProperties)", event: .debug)
                
                time                =   globalProperties.time.convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
                headBlockID         =   globalProperties.head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
                headBlockNumber     =   UInt16(globalProperties.head_block_number & 0xFFFF)
                
                completion(true)
            }
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
