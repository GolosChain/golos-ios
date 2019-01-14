//
//  Broadcast.swift
//  GoloSwift
//
//  Created by msm72 on 15.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

/// Array of request unique IDs
public var requestIDs   =   [Int]()

/// Type of request API
public typealias RequestMethodAPIType               =   (id: Int, requestMessage: String?, startTime: Date, methodAPIType: MethodAPIType, errorAPI: ErrorAPI?)
public typealias RequestOperationAPIType            =   (id: Int, requestMessage: String?, startTime: Date, operationAPIType: OperationAPIType, errorAPI: ErrorAPI?)
public typealias RequestMicroserviceMethodAPIType   =   (id: Int, requestMessage: String?, startTime: Date, microserviceMethodAPIType: MicroserviceMethodAPIType, errorAPI: ErrorAPI?)

/// Type of response API
public typealias ResponseAPIType    =   (responseAPI: Decodable?, errorAPI: ErrorAPI?)
public typealias ResultAPIHandler   =   (Decodable) -> Void
public typealias ErrorAPIHandler    =   (ErrorAPI) -> Void

/// Type of stored request API
public typealias RequestMethodAPIStore              =   (methodAPIType: RequestMethodAPIType, completion: (ResponseAPIType) -> Void)
public typealias RequestOperationAPIStore           =   (operationAPIType: RequestOperationAPIType, completion: (ResponseAPIType) -> Void)
public typealias RequestMicroserviceMethodAPIStore  =   (microserviceMethodAPIType: RequestMicroserviceMethodAPIType, completion: (ResponseAPIType) -> Void)


public class Broadcast {
    // MARK: - Properties
    public static let shared = Broadcast()
    
    
    // MARK: - Class Initialization
    private init() {}
    
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
            onError(ErrorAPI.requestFailed(message: "Broadcast, line 73: \(requestAPIType.errorAPI!.localizedDescription)"))
            return
        }
        
        Logger.log(message: "\nrequestAPIType:\n\t\(requestMessage)\n", event: .debug)
        
        // Send GET Request messages to Blockchain
        WebSocketManager.instanceBlockchain.sendGETRequest(withMethodAPIType: requestAPIType, completion: { responseAPIType in
            if let responseAPI = responseAPIType.responseAPI {
                onResult(responseAPI)
            }
                
            else {
                onError(ErrorAPI.responseUnsuccessful(message: "Broadcast, line 86: \(responseAPIType.errorAPI!.localizedDescription)"))
            }
        })
    }
    
    
    /// Prepare GET API request
    private func prepareGET(requestByMethodAPIType methodAPIType: MethodAPIType) -> RequestMethodAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId(forType: methodAPIType)
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
                jsonData = try jsonEncoder.encode(requestParams as? RequestParameterAPI.Discussion)
                
            case .getUserReplies(_), .getUserFollowCounts(_), .getContent(_), .getContentAllReplies(_), .getUserFollowers(_), .getUserFollowings(_), .getActiveVotes(_):
                jsonData            =   Data((requestParams as! String).utf8)
                
            case .getUserBlogEntries(_):
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
            
//            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
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
    public func executePOST(requestByOperationAPIType operationAPIType: OperationAPIType, userNickName: String, onResult: @escaping (Decodable) -> Void, onError: @escaping (ErrorAPI) -> Void) {
        // API `get_dynamic_global_properties`
        self.getDynamicGlobalProperties(completion: { properties in
            guard let globalProperties = properties else {
                onError(ErrorAPI.requestFailed(message: "Dynamic Global Properties Error"))
                return
            }
            
            // Create Operations for Transaction (tx)
            let operations: [Encodable] = operationAPIType.introduced().paramsSecond
            Logger.log(message: "\nexecutePOST - operations:\n\t\(operations)\n", event: .debug)
            
            // Create Transaction (tx)
            var tx: Transaction = Transaction(forUser: userNickName, withOperations: operations, andGlobalProperties: globalProperties)
            Logger.log(message: "\nexecutePOST - transaction:\n\t\(tx)\n", event: .debug)
            
            // Transaction (tx): serialize & SHA256 & ECC signing
            let serializeResult = tx.serialize(byOperationAPIType: operationAPIType)
            
            guard serializeResult.1 == nil else {
                // Show alert error
                Logger.log(message: "\(serializeResult.1!.localizedDescription)", event: .error)
                onError(serializeResult.1!)
                return
            }
            
            // Send POST Request messages to Blockchain
            switch operationAPIType {
            case .voteAuth:
                let microserviceMethodAPIType = MicroserviceMethodAPIType.auth(user: userNickName, sign: serializeResult.0!)
                
                // Send POST to Microservice
                WebSocketManager.instanceMicroservices.sendGETRequest(withMicroserviceMethodAPIType: self.prepareGET(requestByMicroserviceMethodAPIType: microserviceMethodAPIType), completion: { responseAPIType in
                    if let responseAPI = responseAPIType.responseAPI {
                        onResult(responseAPI)
                    }
                        
                    else {
                        onError(ErrorAPI.responseUnsuccessful(message: "Broadcast, line 197: \(responseAPIType.errorAPI!.localizedDescription)"))
                    }
                })
                
            default:
                // Create POST message
                let requestOperationAPIType = self.preparePOST(requestByOperationAPIType: operationAPIType, byTransaction: tx)
                Logger.log(message: "\nexecutePOST - requestOperationAPIType:\n\t\(requestOperationAPIType.requestMessage!)\n", event: .debug)
                
                guard requestOperationAPIType.errorAPI == nil else {
                    onError(ErrorAPI.requestFailed(message: "Broadcast, line 186: \(requestOperationAPIType.requestMessage!)"))
                    return
                }
                
                // Send POST message to Blockchain
                WebSocketManager.instanceBlockchain.sendPOSTRequest(withOperationAPIType: requestOperationAPIType, completion: { responseAPIType in
                    if let responseAPI = responseAPIType.responseAPI {
                        onResult(responseAPI)
                    }
                        
                    else {
                        onError(ErrorAPI.responseUnsuccessful(message: "Broadcast, line 197: \(responseAPIType.errorAPI!.localizedDescription)"))
                    }
                })
            }
        })
    }
    
    
    /// Gate-Service: 'auth'
    public func executeFakePOST(requestByOperationAPIType operationAPIType: OperationAPIType, userNickName: String, onResult: @escaping (Decodable) -> Void, onError: @escaping (ErrorAPI) -> Void) {
        // Create Operations for Transaction (tx)
        let operations: [Encodable] = operationAPIType.introduced().paramsSecond
        Logger.log(message: "\nexecutePOST - operations:\n\t\(operations)\n", event: .debug)
        
        // Create Transaction (tx)
        var tx: Transaction = Transaction(forFakeUser: userNickName, withOperations: operations)
        Logger.log(message: "\nexecutePOST - transaction:\n\t\(tx)\n", event: .debug)
        
        // Transaction (tx): serialize & SHA256 & ECC signing
        let serializeResult = tx.serialize(byOperationAPIType: operationAPIType)
        
        guard serializeResult.1 == nil else {
            // Show alert error
            Logger.log(message: "\(serializeResult.1!.localizedDescription)", event: .error)
            onError(serializeResult.1!)
            return
        }
        
        // Send POST Request messages to Blockchain
        let microserviceMethodAPIType = MicroserviceMethodAPIType.auth(user: userNickName, sign: serializeResult.0!)
        
        // Send POST to Microservice
        WebSocketManager.instanceMicroservices.sendGETRequest(withMicroserviceMethodAPIType: self.prepareGET(requestByMicroserviceMethodAPIType: microserviceMethodAPIType), completion: { responseAPIType in
            if let responseAPI = responseAPIType.responseAPI {
                onResult(responseAPI)
            }
                
            else {
                onError(ErrorAPI.responseUnsuccessful(message: "Broadcast, line 197: \(responseAPIType.errorAPI!.localizedDescription)"))
            }
        })
    }
    
    
    /// Prepare POST Request API
    private func preparePOST(requestByOperationAPIType operationAPIType: OperationAPIType, byTransaction transaction: Transaction) -> RequestOperationAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId(forType: operationAPIType)
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
                let operationString =   (RequestParameterAPI.decodeToString(model: operation as! RequestParameterAPIOperationPropertiesSupport) ?? "xxx")
                Logger.log(message: "\noperationString:\n\t\(operationString)", event: .debug)
                jsonChainString     +=  (operationString + "}]]}]]}").replacingOccurrences(of: "\"}}]]}", with: "\"}]]}")
                
                if operation is RequestParameterAPI.Vote {
                    jsonChainString =  jsonChainString.replacingOccurrences(of: "}}]]}", with: "}]]}")
                }
                
                Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            }
            
            return (id: codeID, requestMessage: jsonChainString, startTime: Date(), operationAPIType: requestParamsType.operationAPIType, errorAPI: nil)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return (id: codeID, requestMessage: nil, startTime: Date(), operationAPIType: requestParamsType.operationAPIType, errorAPI: ErrorAPI.requestFailed(message: "Broadcast, line 287: \(error.localizedDescription)"))
        }
    }
    
    
    /// API `get_dynamic_global_properties`
    public func getDynamicGlobalProperties(completion: @escaping (ResponseAPIDynamicGlobalProperty?) -> Void) {
        let requestMethodAPIType  =   self.prepareGET(requestByMethodAPIType: .getDynamicGlobalProperties())
        Logger.log(message: "\nrequestAPIType =\n\t\(requestMethodAPIType)", event: .debug)
        
        // Network Layer (WebSocketManager)
        DispatchQueue.main.async {
            WebSocketManager.instanceBlockchain.sendGETRequest(withMethodAPIType: requestMethodAPIType, completion: { responseAPIType in
                Logger.log(message: "\nresponseAPIType:\n\t\(responseAPIType)", event: .debug)
                
                guard   let responseAPI         =   responseAPIType.responseAPI,
                    let responseAPIResult   =   responseAPI as? ResponseAPIDynamicGlobalPropertiesResult,
                    let globalProperties    =   responseAPIResult.result else {
                        Logger.log(message: responseAPIType.errorAPI!.caseInfo.message, event: .error)
                        completion(nil)
                        return
                }
                
                completion(globalProperties)
            })
        }
    }
    
    
    /// Generating a unique ID
    //  for method:                 < 100
    //  for operation:              100 < ??? < 200
    //  for microserviceMethod:     200 < ??? < 300
    private func generateUniqueId(forType type: Any) -> Int {
        var generatedID = 0
        
        repeat {
            if type is MethodAPIType {
                generatedID = Int(arc4random_uniform(100))
            }
                
            else if type is OperationAPIType {
                generatedID = Int(arc4random_uniform(100)) + 100
            }
                
            else if type is MicroserviceMethodAPIType {
                generatedID = Int(arc4random_uniform(100)) + 200
            }
        } while requestIDs.contains(generatedID)
        
        requestIDs.append(generatedID)
        
        return generatedID
    }
}


// MARK: - Microservices
extension Broadcast {
    ///
    public func executeGET(byMicroserviceMethodAPIType microserviceMethodAPIType: MicroserviceMethodAPIType, onResult: @escaping (Decodable) -> Void, onError: @escaping (ErrorAPI) -> Void) {
        // Create GET Request messages to microservice
        let requestAPIType = self.prepareGET(requestByMicroserviceMethodAPIType: microserviceMethodAPIType)
        
        guard requestAPIType.errorAPI == nil else {
            onError(ErrorAPI.requestFailed(message: "Broadcast, line 352: \(requestAPIType.errorAPI!.localizedDescription)"))
            return
        }
        
//        Logger.log(message: "\nrequestMicroserviceMethodAPIType:\n\t\(requestMessage)\n", event: .debug)
        
        // Send GET Request messages to microservice
        WebSocketManager.instanceMicroservices.sendGETRequest(withMicroserviceMethodAPIType: requestAPIType, completion: { responseAPIType in
            if let responseAPI = responseAPIType.responseAPI {
                onResult(responseAPI)
            }
                
            else {
                onError(ErrorAPI.responseUnsuccessful(message: "Broadcast, line 365: \(requestAPIType.errorAPI!.localizedDescription)"))
            }
        })
    }
    
    ///
    private func prepareGET(requestByMicroserviceMethodAPIType microserviceMethodAPIType: MicroserviceMethodAPIType) -> RequestMicroserviceMethodAPIType {
        Logger.log(message: "Success", event: .severe)
        
        let codeID              =   generateUniqueId(forType: microserviceMethodAPIType)
        let requestParamsType   =   microserviceMethodAPIType.introduced()
        
        let requestAPI          =   RequestAPI(id:          codeID,
                                               method:      requestParamsType.nameAPI,
                                               jsonrpc:     "2.0",
                                               params:      requestParamsType.parameters)
        
        do {
            // Encode data
            let jsonEncoder     =   JSONEncoder()
            var jsonData        =   Data()
            var jsonString: String
            
            switch microserviceMethodAPIType {
            case .getSecretKey(_), .auth(_), .setBasicOptions(_), .getOptions(_), .setPushOptions(_):
                jsonData        =   try jsonEncoder.encode(requestAPI)
                jsonString      =   "\(String(data: jsonData, encoding: .utf8)!)"
            }
            
            jsonString          =   jsonString
                                        .replacingOccurrences(of: "[[[", with: "[[")
                                        .replacingOccurrences(of: "[\"nil\"]", with: "]")
            
            if  microserviceMethodAPIType.introduced().nameAPI == "auth"        ||
                microserviceMethodAPIType.introduced().nameAPI == "setOptions"  ||
                microserviceMethodAPIType.introduced().nameAPI == "getOptions"  {
                jsonString      =   jsonString
                                        .replacingOccurrences(of: "[", with: "{")
                                        .replacingOccurrences(of: "]", with: "}")
                                        .replacingOccurrences(of: "\\", with: "")
            }
            
            if microserviceMethodAPIType.introduced().nameAPI == "setOptions" {
                jsonString      =   jsonString
                    .replacingOccurrences(of: "}\"}}", with: "}}}")
            }
            
            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
            // (id: Int, requestMessage: String?, startTime: Date, microserviceMethodAPIType: MicroserviceMethodAPIType, errorAPI: ErrorAPI?)
            return (id: codeID, requestMessage: jsonString, startTime: Date(), microserviceMethodAPIType: requestParamsType.microserviceMethodAPIType, errorAPI: nil)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            
            // (id: Int, requestMessage: String?, startTime: Date, microserviceMethodAPIType: MicroserviceMethodAPIType, errorAPI: ErrorAPI?)
            return (id: codeID, requestMessage: nil, startTime: Date(), microserviceMethodAPIType: requestParamsType.microserviceMethodAPIType, errorAPI: ErrorAPI.requestFailed(message: "Broadcast, line 406: \(error.localizedDescription)"))
        }
    }
}
