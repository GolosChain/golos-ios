//
//  WebsocketManager.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Starscream

class WebSocketManager {
    // MARK: - Properties
    private var requestsAPIStore = [Int: RequestAPIStore]()
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Custom Functions
    func connect() {
        Logger.log(message: "Success", event: .severe)

        if webSocket.isConnected { return }
        webSocket.connect()
    }
    
    func disconnect() {
        Logger.log(message: "Success", event: .severe)

        guard webSocket.isConnected else { return }
        
        // Clean store lists
        requestsAPIStore = [Int: RequestAPIStore]()
        requestIDs = [Int]()
       
        webSocket.disconnect()
    }
    
    func sendMessage(_ message: String) {
        Logger.log(message: "Success", event: .severe)
        webSocket.write(string: message)
    }
    
    /// Websocket: send message
    func sendRequest(withType type: RequestAPIType, completion: @escaping (ResponseAPIType) -> Void) {
        Logger.log(message: "Success", event: .severe)
        
        let requestStore = (type: type, completion: completion)
        requestsAPIStore[type.id] = requestStore
        
        webSocket.isConnected ? sendMessage(type.message) : webSocket.connect()
    }
}


// MARK: - WebSocketDelegate
extension WebSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        Logger.log(message: "Success", event: .severe)
        
        guard requestsAPIStore.count > 0 else {
            return
        }
        
        Logger.log(message: "requestsApiStore = \(requestsAPIStore)", event: .debug)
        for (_, requestApiStore) in requestsAPIStore {
            sendMessage(requestApiStore.type.message)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        Logger.log(message: "Success", event: .severe)
        var responseAPIResult: Decodable!
        
        if let jsonData = text.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as! [String: Any] {
//            Logger.log(message: "json:\n\t\(json)", event: .debug)

            // Check error.
            Validator.validate(json: json, completion: { (codeID, hasError) in
                // Check request by sended ID
                guard let requestAPIStore = self.requestsAPIStore[codeID] else {
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    if hasError {
                        responseAPIResult = try jsonDecoder.decode(ResponseAPIResultError.self, from: jsonData)
                    }
                        
                    else {
                        responseAPIResult = try jsonDecoder.decode(ResponseAPIResult.self, from: jsonData)
                    }

                    print("responseAPIResult model:\n\t\(responseAPIResult)")
                    
                    // Check websocket timeout: resend current request message
                    let timeout = Double(Date().timeIntervalSince(requestAPIStore.type.startTime))
                    Logger.log(message: "webSocket timeout = \(timeout) sec", event: .debug)
                    
                    if timeout >= webSocketTimeout {
                        let newRequestAPIStore = (type: (id: requestAPIStore.type.id, message: requestAPIStore.type.message, startTime: Date()), completion: requestAPIStore.completion)
                        self.requestsAPIStore[codeID] = newRequestAPIStore
                        self.sendMessage(newRequestAPIStore.type.message)
                    }
                        
                    // Check websocket timeout: handler completion
                    else {
                        // Remove requestStore
                        self.requestsAPIStore[codeID] = nil
                        
                        // Remove unique request ID
                        if let requestID = requestIDs.index(of: codeID) {
                            requestIDs.remove(at: requestID)
                        }
                        
                        requestAPIStore.completion((responseType: responseAPIResult, hasError: hasError))
                    }
                } catch {
                    print("Error responseAPI model...")
                }
            })
//            if let jsonError = json["error"] as? [String: Any], let errorCode = jsonError["code"] as? Int, let errorMessage = jsonError["message"] as? String {
//                error = NSError(domain:    "io.golos.websocket",
//                                code:      errorCode,
//                                userInfo:  [NSLocalizedDescriptionKey: errorMessage])
//            }
            
        }
        
//        guard let response = WebSocketResponse(withText: text) else {
//            return
//        }
        
    }
    
    // Not used
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        Logger.log(message: "Success", event: .severe)
        
        self.disconnect()
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        Logger.log(message: "Success", event: .severe)
    }
}
