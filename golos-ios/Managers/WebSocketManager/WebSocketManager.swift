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
    private var requestsApiStore = [Int: RequestApiStore]()
    
    
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
        requestsApiStore = [Int: RequestApiStore]()
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
        requestsApiStore[type.id] = requestStore
        
        webSocket.isConnected ? sendMessage(type.message) : webSocket.connect()
    }
}


// MARK: - WebSocketDelegate
extension WebSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        Logger.log(message: "Success", event: .severe)
        
        guard requestsApiStore.count > 0 else {
            return
        }
        
        Logger.log(message: "requestsApiStore = \(requestsApiStore)", event: .debug)
        for (_, requestApiStore) in requestsApiStore {
            sendMessage(requestApiStore.type.message)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        Logger.log(message: "Success", event: .severe)

        guard let response = WebSocketResponse(withText: text) else {
            return
        }
        
        // Check request by sended ID
        guard let requestApiStore = requestsApiStore[response.requestId] else {
            return
        }
        
        // Check websocket timeout: resend current request message
        let timeout = Double(Date().timeIntervalSince(requestApiStore.type.startTime))
        Logger.log(message: "webSocket timeout = \(timeout) sec", event: .debug)
        
        if timeout >= webSocketTimeout {
            let requestStore = (type: (id: requestApiStore.type.id, message: requestApiStore.type.message, startTime: Date()), completion: requestApiStore.completion)
            requestsApiStore[response.requestId] = requestStore
            self.sendMessage(requestApiStore.type.message)
        }
        
        // Check websocket timeout: handler completion
        else {
            // Remove requestStore
            requestsApiStore[requestApiStore.type.id] = nil
            
            // Remove unique request ID
            if let requestID = requestIDs.index(of: response.requestId) {
                requestIDs.remove(at: requestID)
            }
            
            requestApiStore.completion((response: response.result as? [[String : Any]], error: response.error))
        }
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
