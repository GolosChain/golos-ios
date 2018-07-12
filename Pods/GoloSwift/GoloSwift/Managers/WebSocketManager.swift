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
    private var requestsAPIStore = [Int: RequestAPIStore]()
    
    
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
        
        // Clean store lists
        requestsAPIStore = [Int: RequestAPIStore]()
        requestIDs = [Int]()
       
        webSocket.disconnect()
    }
    
    public func sendMessage(_ message: String) {
        Logger.log(message: "Success", event: .severe)
        webSocket.write(string: message)
    }
    
    /// Websocket: send message
    public func sendRequest(withType type: RequestAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        Logger.log(message: "Success", event: .severe)
        
        let requestStore = (type: type, completion: completion)
        requestsAPIStore[type.id] = requestStore
        
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
        Logger.log(message: json.description, event: .debug)
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
            switch methodAPIType {
            // GET
            case .getAccounts(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIUserResult.self, from: jsonData), errorAPI: nil)
                
            case .getDynamicGlobalProperties():
                return (responseAPI: try JSONDecoder().decode(ResponseAPIDynamicGlobalPropertiesResult.self, from: jsonData), errorAPI: nil)
                
            case .getDiscussions(_), .getUserReplies(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIFeedResult.self, from: jsonData), errorAPI: nil)
                
            case .getAllContentReplies(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIAllContentRepliesResult.self, from: jsonData), errorAPI: nil)

                
            // POST
            case .verifyAuthorityVote:
                return (responseAPI: try JSONDecoder().decode(ResponseAPIVerifyAuthorityResult.self, from: jsonData), errorAPI: nil)
            
            case .post(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIVerifyAuthorityResult.self, from: jsonData), errorAPI: nil)
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
        Logger.log(message: "Success", event: .severe)
        
        guard requestsAPIStore.count > 0 else {
            return
        }
        
        Logger.log(message: "\nrequestsAPIStore =\n\t\(requestsAPIStore)", event: .debug)
        
        for (_, requestApiStore) in requestsAPIStore {
            sendMessage(requestApiStore.type.requestMessage!)
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        Logger.log(message: "Success", event: .severe)
        var responseAPIType: ResponseAPIType
        
        if let jsonData = text.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as! [String: Any] {
            // Check error
            self.validate(json: json, completion: { [weak self] (codeID, hasError) in
                // Check request by sended ID
                guard let requestAPIStore = self?.requestsAPIStore[codeID] else {
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    if hasError {
                        let responseAPIResultError = try jsonDecoder.decode(ResponseAPIResultError.self, from: jsonData)
                        self?.errorAPI = ErrorAPI.requestFailed(message: responseAPIResultError.error.message.components(separatedBy: "second.end(): ").last!)
                    }
                        
                    responseAPIType = (try self?.decode(from: jsonData, byMethodAPIType: requestAPIStore.type.methodAPIType))!
                    
                    guard let responseAPIResult = responseAPIType.responseAPI else {
                        self?.errorAPI = responseAPIType.errorAPI
                        return requestAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                    }

//                    Logger.log(message: "\nresponseAPIResult model:\n\t\(responseAPIResult)", event: .debug)
                    
                    // Check websocket timeout: resend current request message
                    let timeout = Double(Date().timeIntervalSince(requestAPIStore.type.startTime))
                    Logger.log(message: "\nwebSocket timeout =\n\t\(timeout) sec", event: .debug)
                    
                    if timeout >= webSocketTimeout {
                        let newRequestAPIStore = (type: (id: requestAPIStore.type.id, requestMessage: requestAPIStore.type.requestMessage, startTime: Date(), methodAPIType: requestAPIStore.type.methodAPIType, errorAPI: requestAPIStore.type.errorAPI), completion: requestAPIStore.completion)
                        self?.requestsAPIStore[codeID] = newRequestAPIStore
                        self?.sendMessage(newRequestAPIStore.type.requestMessage!)
                    }
                        
                    // Check websocket timeout: handler completion
                    else {
                        // Remove requestStore
                        self?.requestsAPIStore[codeID] = nil
                        
                        // Remove unique request ID
                        if let requestID = requestIDs.index(of: codeID) {
                            requestIDs.remove(at: requestID)
                        }
                        
                        requestAPIStore.completion((responseAPI: responseAPIResult, errorAPI: self?.errorAPI))
                    }
                } catch {
                    Logger.log(message: "\nResponse Unsuccessful:\n\t\(error.localizedDescription)", event: .error)
                    self?.errorAPI = ErrorAPI.responseUnsuccessful(message: error.localizedDescription)
                    requestAPIStore.completion((responseAPI: nil, errorAPI: self?.errorAPI))
                }
            })
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
