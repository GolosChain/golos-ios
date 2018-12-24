//
//  WebsocketManager.swift
//  GoloSwift
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation
import Starscream

public enum WebSocketManagerMode {
    case blockchain
    case microservices
}

public class WebSocketManager {
    // MARK: - Properties
    private var mode: WebSocketManagerMode  =   .blockchain
    public var webSocket: WebSocket         =   webSocketBlockchain
    
    public static let instanceBlockchain    =   WebSocketManager(withMode: .blockchain)
    public static let instanceMicroservices =   WebSocketManager(withMode: .microservices)
    
    private var errorAPI: ErrorAPI?
    private var requestMethodsAPIStore              =   [Int: RequestMethodAPIStore]()
    private var requestOperationsAPIStore           =   [Int: RequestOperationAPIStore]()
    private var requestMicroserviceMethodsAPIStore  =   [Int: RequestMicroserviceMethodAPIStore]()
    
    // Handlers
    public var completionIsConnected: (() -> Void)?
    
    
    // MARK: - Class Initialization
    private init() {}
    
    init(withMode mode: WebSocketManagerMode = .blockchain) {
        self.mode       =   mode
        self.webSocket  =   mode == .blockchain ? webSocketBlockchain : webSocketMicroservices
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Custom Functions
    public func connect() {
        Logger.log(message: "Success", event: .severe)
        
        if self.webSocket.isConnected { return }
        
        self.webSocket.connect()
    }
    
    public func disconnect() {
        Logger.log(message: "Success", event: .severe)
        
        guard self.webSocket.isConnected else { return }
        
        let requestMethodAPIStore       =   self.requestMethodsAPIStore.first?.value
        let requestOperationAPIStore    =   self.requestOperationsAPIStore.first?.value
        let isSendedRequestMethodAPI    =   requestOperationAPIStore == nil
        
        isSendedRequestMethodAPI ?  requestMethodAPIStore!.completion((responseAPI: nil, errorAPI: ErrorAPI.responseUnsuccessful(message: "No Internet Connection"))) :
            requestOperationAPIStore!.completion((responseAPI: nil, errorAPI: ErrorAPI.responseUnsuccessful(message: "No Internet Connection")))
        
        // Clean store lists
        requestIDs                      =   [Int]()
        self.requestMethodsAPIStore     =   [Int: RequestMethodAPIStore]()
        self.requestOperationsAPIStore  =   [Int: RequestOperationAPIStore]()
        
        self.webSocket.disconnect()
    }
    
    public func sendMessage(_ message: String) {
        Logger.log(message: "\nrequestMessage = \n\t\(message)", event: .debug)
        self.webSocket.write(string: message)
    }
    
    
    /// Blockchain: send GET Request message
    public func sendGETRequest(withMethodAPIType type: RequestMethodAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        let requestMethodAPITypeStore           =   (methodAPIType: type, completion: completion)
        self.requestMethodsAPIStore[type.id]    =   requestMethodAPITypeStore
        
        self.webSocket.isConnected ? sendMessage(type.requestMessage!) : self.webSocket.connect()
    }
    
    
    /// Microservices: send GET Request message
    public func sendGETRequest(withMicroserviceMethodAPIType type: RequestMicroserviceMethodAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        let requestMicroserviceMethodAPITypeStore           =   (microserviceMethodAPIType: type, completion: completion)
        self.requestMicroserviceMethodsAPIStore[type.id]    =   requestMicroserviceMethodAPITypeStore
        
        self.webSocket.isConnected ? sendMessage(type.requestMessage!) : self.webSocket.connect()
    }
    
    
    /// Websocket: send POST Request messages
    public func sendPOSTRequest(withOperationAPIType type: RequestOperationAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        let requestOperationAPITypeStore        =   (operationAPIType: type, completion: completion)
        self.requestOperationsAPIStore[type.id] =   requestOperationAPITypeStore
        
        self.webSocket.isConnected ? sendMessage(type.requestMessage!) : self.webSocket.connect()
    }
    
    
    /**
     Checks `JSON` for an error.
     
     - Parameter json: Input response dictionary.
     - Parameter completion: Return two values:
     - Parameter codeID: Request ID.
     - Parameter hasError: Error indicator.
     
     */
    private func validate(json: [String: Any], completion: @escaping (_ codeID: Int, _ hasError: Bool) -> Void) {
//        Logger.log(message: json.description, event:6 .debug)
        guard let id = json["id"] as? Int else {
            if let method = json["method"] as? String, method == "sign" {
                self.completionIsConnected!()
            }
            
            return
        }
        
        completion(id, json["error"] != nil)
    }
    
    
    /**
     Decode blockchain response.
     
     - Parameter jsonData: The `Data` of response.
     - Parameter methodAPIType: The type of API method.
     - Returns: Return `RequestAPIType` tuple.
     
     */
    func decode(from jsonData: Data, byMethodAPIType methodAPIType: MethodAPIType) throws -> ResponseAPIType {
        do {
            // GET
            switch methodAPIType {
            case .getAccounts(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIUserResult.self, from: jsonData), errorAPI: nil)
                
            case .getDynamicGlobalProperties():
                return (responseAPI: try JSONDecoder().decode(ResponseAPIDynamicGlobalPropertiesResult.self, from: jsonData), errorAPI: nil)
                
            case .getDiscussions(_), .getUserReplies(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIPostsResult.self, from: jsonData), errorAPI: nil)
                
            case .getUserFollowCounts(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIUserFollowCountsResult.self, from: jsonData), errorAPI: nil)
                
            case .getUserFollowings(_), . getUserFollowers(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIUserFollowingsResult.self, from: jsonData), errorAPI: nil)
                
            case .getContent(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIPostResult.self, from: jsonData), errorAPI: nil)
                
            case .getContentAllReplies(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIPostsResult.self, from: jsonData), errorAPI: nil)
                
            case .getActiveVotes(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIVoterResult.self, from: jsonData), errorAPI: nil)
                
            case .getUserBlogEntries(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIEntryResult.self, from: jsonData), errorAPI: nil)
            }
        } catch {
            Logger.log(message: "\(error)", event: .error)
            return (responseAPI: nil, errorAPI: ErrorAPI.jsonParsingFailure(message: error.localizedDescription))
        }
    }
    
    func decode(from jsonData: Data, byOperationAPIType operationAPIType: OperationAPIType) throws -> ResponseAPIType {
        do {
            // POST
            switch operationAPIType {
            case .vote(_), .voteAuth(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIBlockchainPostResult.self, from: jsonData), errorAPI: nil)
                
            case .comment(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIBlockchainPostResult.self, from: jsonData), errorAPI: nil)
                
            case .commentOptions(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIBlockchainPostResult.self, from: jsonData), errorAPI: nil)
                
            case .createPost(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIBlockchainPostResult.self, from: jsonData), errorAPI: nil)
                
            case .subscribe(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIBlockchainPostResult.self, from: jsonData), errorAPI: nil)
            }
        } catch {
            Logger.log(message: "\(error)", event: .error)
            return (responseAPI: nil, errorAPI: ErrorAPI.jsonParsingFailure(message: error.localizedDescription))
        }
    }
    
    func decode(from jsonData: Data, byMicroserviceMethodAPIType microserviceMethodAPIType: MicroserviceMethodAPIType) throws -> ResponseAPIType {
        do {
            // Gate microservices
            switch microserviceMethodAPIType {
            case .auth(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIMicroserviceAuthResult.self, from: jsonData), errorAPI: nil)
                
            case .getSecretKey(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIMicroserviceSecretResult.self, from: jsonData), errorAPI: nil)
            }
        } catch {
            Logger.log(message: "\(error)", event: .error)
            return (responseAPI: nil, errorAPI: ErrorAPI.jsonParsingFailure(message: error.localizedDescription))
        }
    }
}


// MARK: - WebSocketDelegate
extension WebSocketManager: WebSocketDelegate {
    public func websocketDidConnect(socket: WebSocketClient) {
        guard requestIDs.count > 0 else {
            return
        }
        
        Logger.log(message: "\nrequestIDs =\n\t\(requestIDs)", event: .debug)
        
        // Send all stored GET & POST Request messages
        requestIDs.forEach({ id in
            switch id {
            case 0..<100:
                if let methodRequestAPI = self.requestMethodsAPIStore.first(where: { $0.key == id }) {
                    self.sendMessage(methodRequestAPI.value.methodAPIType.requestMessage!)
                }
                
            case 100..<200:
                if let operationRequestAPI = self.requestOperationsAPIStore.first(where: { $0.key == id }) {
                    self.sendMessage(operationRequestAPI.value.operationAPIType.requestMessage!)
                }
                
            case 200..<300:
                if let microserviceMethodRequestAPI = self.requestMicroserviceMethodsAPIStore.first(where: { $0.key == id }) {
                    self.sendMessage(microserviceMethodRequestAPI.value.microserviceMethodAPIType.requestMessage!)
                }
                
            default:
                break
            }
        })
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        Logger.log(message: "Success", event: .severe)
        var responseAPIType: ResponseAPIType?
        
        if let jsonData = text.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as! [String: Any] {
            // Check error
            self.validate(json: json, completion: { [weak self] (codeID, hasError) in
                guard requestIDs.count > 0, requestIDs.contains(codeID) else {
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    if hasError {
                        let responseAPIResultError = try jsonDecoder.decode(ResponseAPIResultError.self, from: jsonData)
                        self?.errorAPI = ErrorAPI.requestFailed(message: responseAPIResultError.error.message.components(separatedBy: "second.end(): ").last!)
                    }
                    
                    // Method API's
                    if codeID < 100 {
                        guard let requestMethodAPIStore = self?.requestMethodsAPIStore[codeID] else { return }
                        
                        responseAPIType = try self?.decode(from: jsonData, byMethodAPIType: requestMethodAPIStore.methodAPIType.methodAPIType)
                        
                        guard let responseAPIResult = responseAPIType?.responseAPI else {
                            self?.errorAPI = responseAPIType?.errorAPI ?? ErrorAPI.invalidData(message: "Response Unsuccessful")
                            
                            return  requestMethodAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                        }
                        
                        //                        Logger.log(message: "\nresponseMethodAPIResult model:\n\t\(responseAPIResult)", event: .debug)
                        
                        // Check websocket timeout: resend current request message
                        self?.checkTimeout(result: responseAPIResult, requestAPIStore: requestMethodAPIStore)
                    }
                        
                    // Operation API's
                    else if 100..<200 ~= codeID {
                        guard let requestOperationAPIStore = self?.requestOperationsAPIStore[codeID] else { return }
                        
                        responseAPIType = try self?.decode(from: jsonData, byOperationAPIType: requestOperationAPIStore.operationAPIType.operationAPIType)
                        
                        guard let responseAPIResult = responseAPIType?.responseAPI else {
                            self?.errorAPI = responseAPIType?.errorAPI ?? ErrorAPI.invalidData(message: "Response Unsuccessful")
                            
                            return requestOperationAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                        }
                        
//                        Logger.log(message: "\nresponseOperationAPIResult model:\n\t\(responseAPIResult)", event: .debug)
                        
                        // Check websocket timeout: resend current request message
                        self?.checkTimeout(result: responseAPIResult, requestAPIStore: requestOperationAPIStore)
                    }
                        
                    // Microservice API's
                    else if 200..<300 ~= codeID {
                        guard let requestMicroserviceMethodAPIStore = self?.requestMicroserviceMethodsAPIStore[codeID] else { return }
                        
                        responseAPIType = try self?.decode(from: jsonData, byMicroserviceMethodAPIType: requestMicroserviceMethodAPIStore.microserviceMethodAPIType.microserviceMethodAPIType)
                        
                        guard let responseAPIResult = responseAPIType?.responseAPI else {
                            self?.errorAPI = responseAPIType?.errorAPI ?? ErrorAPI.invalidData(message: "Response Unsuccessful")
                            
                            return requestMicroserviceMethodAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                        }
                        
                        Logger.log(message: "\nresponseMicroserviceAPIResult model:\n\t\(responseAPIResult)", event: .debug)
                        
                        // Check websocket timeout: resend current request message
                        self?.checkTimeout(result: responseAPIResult, requestAPIStore: requestMicroserviceMethodAPIStore)
                    }
                } catch {
                    Logger.log(message: "\nResponse Unsuccessful:\n\t\(error.localizedDescription)", event: .error)
                    self?.errorAPI = ErrorAPI.responseUnsuccessful(message: error.localizedDescription)
                    
                    if let requestMethodAPIStore = self?.requestMethodsAPIStore[codeID] {
                        requestMethodAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                    }
                        
                    else if let requestOperationAPIStore = self?.requestOperationsAPIStore[codeID] {
                        requestOperationAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                    }
                        
                    else if let requestMicroserviceMethodAPIStore = self?.requestMicroserviceMethodsAPIStore[codeID] {
                        requestMicroserviceMethodAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                    }
                        
                    else { return }
                }
            })
        }
    }
    
    private func checkTimeout(result: Decodable, requestAPIStore: Any) {
        var codeID: Int     =   0
        var startTime: Date =   Date()
        
        if let requestMethodAPIStore = requestAPIStore as? RequestMethodAPIStore {
            codeID      =   requestMethodAPIStore.methodAPIType.id
            startTime   =   requestMethodAPIStore.methodAPIType.startTime
        }
            
        else if let requestOperationAPIStore = requestAPIStore as? RequestOperationAPIStore {
            codeID      =   requestOperationAPIStore.operationAPIType.id
            startTime   =   requestOperationAPIStore.operationAPIType.startTime
        }
            
        else if let requestMicroserviceMethodAPIStore = requestAPIStore as? RequestMicroserviceMethodAPIStore {
            codeID      =   requestMicroserviceMethodAPIStore.microserviceMethodAPIType.id
            startTime   =   requestMicroserviceMethodAPIStore.microserviceMethodAPIType.startTime
        }
        
        let timeout     =   Double(Date().timeIntervalSince(startTime))
        
        Logger.log(message: "\nwebSocket timeout =\n\t\(timeout) sec", event: .debug)
        
        // Check websocket timeout: resend current request message
        if timeout >= webSocketTimeout {
            // GET Request
            if let requestMethodAPIStore = requestAPIStore as? RequestMethodAPIStore {
                let newRequestMethodAPIStore        =   (methodAPIType:  (id:                    codeID,
                                                                          requestMessage:        requestMethodAPIStore.methodAPIType.requestMessage,
                                                                          startTime:             Date(),
                                                                          methodAPIType:         requestMethodAPIStore.methodAPIType.methodAPIType,
                                                                          errorAPI:              requestMethodAPIStore.methodAPIType.errorAPI),
                                                         completion:     requestMethodAPIStore.completion)
                
                self.requestMethodsAPIStore[codeID] = newRequestMethodAPIStore
                self.sendMessage(requestMethodAPIStore.methodAPIType.requestMessage!)
            }
                
            // POST Request
            else if let requestOperationAPIStore = requestAPIStore as? RequestOperationAPIStore {
                let newRequestOperationAPIStore     =   (operationAPIType:    (id:                    codeID,
                                                                               requestMessage:        requestOperationAPIStore.operationAPIType.requestMessage,
                                                                               startTime:             Date(),
                                                                               operationAPIType:      requestOperationAPIStore.operationAPIType.operationAPIType,
                                                                               errorAPI:              requestOperationAPIStore.operationAPIType.errorAPI),
                                                         completion:          requestOperationAPIStore.completion)
                
                self.requestOperationsAPIStore[codeID] = newRequestOperationAPIStore
                self.sendMessage(requestOperationAPIStore.operationAPIType.requestMessage!)
            }
                
            // Microservice Method Request
            else if let requestMicroserviceMethodAPIStore = requestAPIStore as? RequestMicroserviceMethodAPIStore {
                let newRequestMicroserviceMethodAPIStore  =   (microserviceMethodAPIType:   (id:                        codeID,
                                                                                             requestMessage:            requestMicroserviceMethodAPIStore.microserviceMethodAPIType.requestMessage,
                                                                                             startTime:                 Date(),
                                                                                             microserviceMethodAPIType: requestMicroserviceMethodAPIStore.microserviceMethodAPIType.microserviceMethodAPIType,
                                                                                             errorAPI:                  requestMicroserviceMethodAPIStore.microserviceMethodAPIType.errorAPI),
                                                               completion:                  requestMicroserviceMethodAPIStore.completion)
                
                self.requestMicroserviceMethodsAPIStore[codeID] = newRequestMicroserviceMethodAPIStore
                self.sendMessage(requestMicroserviceMethodAPIStore.microserviceMethodAPIType.requestMessage!)
            }
        }
            
        // Check websocket timeout: handler completion
        else {
            // GET Request
            if let requestMethodAPIStore = requestAPIStore as? RequestMethodAPIStore {
                requestMethodAPIStore.completion((responseAPI: result, errorAPI: self.errorAPI))
            }
                
            // POST Request
            else if let requestOperationAPIStore = requestAPIStore as? RequestOperationAPIStore {
                requestOperationAPIStore.completion((responseAPI: result, errorAPI: self.errorAPI))
            }
                
            // Microservice Request
            else if let requestMicroserviceAPIStore = requestAPIStore as? RequestMicroserviceMethodAPIStore {
                requestMicroserviceAPIStore.completion((responseAPI: result, errorAPI: self.errorAPI))
            }
            
            // Clean requestsAPIStore
            self.requestMethodsAPIStore[codeID]                 =   nil
            self.requestOperationsAPIStore[codeID]              =   nil
            self.requestMicroserviceMethodsAPIStore[codeID]     =   nil
            
            // Remove unique request ID
            if let requestID = requestIDs.index(of: codeID) {
                requestIDs.remove(at: requestID)
            }
        }
    }
    
    
    /// Not used
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        Logger.log(message: "Success", event: .severe)
        
        self.disconnect()
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        Logger.log(message: "Success", event: .severe)
    }
}
