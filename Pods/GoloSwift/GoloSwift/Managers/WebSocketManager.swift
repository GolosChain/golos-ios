//
//  WebsocketManager.swift
//  GoloSwift
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation
import Starscream

public class WebSocketManager {
    // MARK: - Properties
    private var errorAPI: ErrorAPI?
    private var requestMethodsAPIStore      =   [Int: RequestMethodAPIStore]()
    private var requestOperationsAPIStore   =   [Int: RequestOperationAPIStore]()
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Custom Functions
    public func connect() {
        Logger.log(message: "Success", event: .severe)
        
        if webSocket.isConnected { return }
        webSocket.connect()
    }
    
    public func disconnect() {
        Logger.log(message: "Success", event: .severe)
        
        guard webSocket.isConnected else { return }
        
        let requestMethodAPIStore       =   self.requestMethodsAPIStore.first?.value
        let requestOperationAPIStore    =   self.requestOperationsAPIStore.first?.value
        let isSendedRequestMethodAPI    =   requestOperationAPIStore == nil
        
        isSendedRequestMethodAPI ?  requestMethodAPIStore!.completion((responseAPI: nil, errorAPI: ErrorAPI.responseUnsuccessful(message: "No Internet Connection"))) :
                                    requestOperationAPIStore!.completion((responseAPI: nil, errorAPI: ErrorAPI.responseUnsuccessful(message: "No Internet Connection")))
        
        // Clean store lists
        requestIDs                      =   [Int]()
        self.requestMethodsAPIStore     =   [Int: RequestMethodAPIStore]()
        self.requestOperationsAPIStore  =   [Int: RequestOperationAPIStore]()
        
        webSocket.disconnect()
    }
    
    public func sendMessage(_ message: String) {
        Logger.log(message: "\nrequestMessage = \n\t\(message)", event: .debug)
        webSocket.write(string: message)
    }
    
    
    /// Websocket: send GET Request message
    public func sendGETRequest(withMethodAPIType type: RequestMethodAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        let requestMethodAPITypeStore           =   (methodAPIType: type, completion: completion)
        self.requestMethodsAPIStore[type.id]    =   requestMethodAPITypeStore
        
        webSocket.isConnected ? sendMessage(type.requestMessage!) : webSocket.connect()
    }
    
    
    /// Websocket: send POST Request messages
    public func sendPOSTRequest(withOperationAPIType type: RequestOperationAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        let requestOperationAPITypeStore        =   (operationAPIType: type, completion: completion)
        self.requestOperationsAPIStore[type.id] =   requestOperationAPITypeStore
        
        webSocket.isConnected ? sendMessage(type.requestMessage!) : webSocket.connect()
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
        completion(json["id"] as! Int, json["error"] != nil)
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
                
            case .getUserFollowings(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIUserFollowingsResult.self, from: jsonData), errorAPI: nil)
                
            case .getContent(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIPostResult.self, from: jsonData), errorAPI: nil)
                
            case .getContentAllReplies(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIAllContentRepliesResult.self, from: jsonData), errorAPI: nil)
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
            case .vote(_):
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
}


// MARK: - WebSocketDelegate
extension WebSocketManager: WebSocketDelegate {
    public func websocketDidConnect(socket: WebSocketClient) {
        guard requestIDs.count > 0 else {
            return
        }
        
        Logger.log(message: "\nrequestIDs =\n\t\(requestIDs)", event: .debug)
        
        // Send all stored GET & POST Request messages
        self.requestMethodsAPIStore.forEach({ sendMessage($0.value.methodAPIType.requestMessage!)})
        self.requestOperationsAPIStore.forEach({ sendMessage($0.value.operationAPIType.requestMessage!)})
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
                
                // Check stored sended Request by received ID
                let isRequestMethodAPIStore = codeID < 500
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    if hasError {
                        let responseAPIResultError = try jsonDecoder.decode(ResponseAPIResultError.self, from: jsonData)
                        self?.errorAPI = ErrorAPI.requestFailed(message: responseAPIResultError.error.message.components(separatedBy: "second.end(): ").last!)
                    }
                    
                    switch isRequestMethodAPIStore {
                    // Method API's
                    case true:
                        guard let requestMethodAPIStore = self?.requestMethodsAPIStore[codeID] else { return }
                        
                        responseAPIType = try self?.decode(from: jsonData, byMethodAPIType: requestMethodAPIStore.methodAPIType.methodAPIType)
                        
                        guard let responseAPIResult = responseAPIType?.responseAPI else {
                            self?.errorAPI = responseAPIType?.errorAPI ?? ErrorAPI.invalidData(message: "Response Unsuccessful")
                            
                            return  requestMethodAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                        }
                        
//                        Logger.log(message: "\nresponseMethodAPIResult model:\n\t\(responseAPIResult)", event: .debug)
                        
                        // Check websocket timeout: resend current request message
                        self?.checkTimeout(result: responseAPIResult, byMethodAPI: true, requestMethodAPIStore: requestMethodAPIStore, requestOperationAPIStore: nil)
                        
                    // Operation API's
                    case false:
                        guard let requestOperationAPIStore = self?.requestOperationsAPIStore[codeID] else { return }
                        
                        responseAPIType = try self?.decode(from: jsonData, byOperationAPIType: requestOperationAPIStore.operationAPIType.operationAPIType)
                        
                        guard let responseAPIResult = responseAPIType?.responseAPI else {
                            self?.errorAPI = responseAPIType?.errorAPI ?? ErrorAPI.invalidData(message: "Response Unsuccessful")
                            
                            return requestOperationAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                        }
                        
//                        Logger.log(message: "\nresponseOperationAPIResult model:\n\t\(responseAPIResult)", event: .debug)
                        
                        // Check websocket timeout: resend current request message
                        self?.checkTimeout(result: responseAPIResult, byMethodAPI: false, requestMethodAPIStore: nil, requestOperationAPIStore: requestOperationAPIStore)
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
                        
                    else { return }
                }
            })
        }
    }
    
    private func checkTimeout(result: Decodable, byMethodAPI: Bool, requestMethodAPIStore: RequestMethodAPIStore?, requestOperationAPIStore: RequestOperationAPIStore?) {
        let startTime   =   byMethodAPI ? requestMethodAPIStore!.methodAPIType.startTime : requestOperationAPIStore!.operationAPIType.startTime
        let timeout     =   Double(Date().timeIntervalSince(startTime))
        let codeID      =   byMethodAPI ? requestMethodAPIStore!.methodAPIType.id : requestOperationAPIStore!.operationAPIType.id
        
        Logger.log(message: "\nwebSocket timeout =\n\t\(timeout) sec", event: .debug)
        
        // Check websocket timeout: resend current request message
        if timeout >= webSocketTimeout {
            switch byMethodAPI {
            // GET Request
            case true:
                let newRequestMethodAPIStore = (methodAPIType:  (id:                    codeID,
                                                                 requestMessage:        requestMethodAPIStore!.methodAPIType.requestMessage,
                                                                 startTime:             Date(),
                                                                 methodAPIType:         requestMethodAPIStore!.methodAPIType.methodAPIType,
                                                                 errorAPI:              requestMethodAPIStore!.methodAPIType.errorAPI),
                                                completion:     requestMethodAPIStore!.completion)
                
                self.requestMethodsAPIStore[codeID] = newRequestMethodAPIStore
                self.sendMessage(requestMethodAPIStore!.methodAPIType.requestMessage!)
                
            // POST Request
            case false:
                let newRequestOperationAPIStore = (operationAPIType:    (id:                    codeID,
                                                                         requestMessage:        requestOperationAPIStore!.operationAPIType.requestMessage,
                                                                         startTime:             Date(),
                                                                         operationAPIType:      requestOperationAPIStore!.operationAPIType.operationAPIType,
                                                                         errorAPI:              requestOperationAPIStore!.operationAPIType.errorAPI),
                                                   completion:          requestOperationAPIStore!.completion)
                
                self.requestOperationsAPIStore[codeID] = newRequestOperationAPIStore
                self.sendMessage(requestOperationAPIStore!.operationAPIType.requestMessage!)
            }
        }
            
            // Check websocket timeout: handler completion
        else {
            byMethodAPI ?   requestMethodAPIStore!.completion((responseAPI: result, errorAPI: self.errorAPI)) :
                            requestOperationAPIStore!.completion((responseAPI: result, errorAPI: self.errorAPI))
            
            // Clean requestsAPIStore
            self.requestMethodsAPIStore[codeID] = nil
            self.requestOperationsAPIStore[codeID] = nil
            
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
