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
//    private var requests = [Int: WebSocketRequest]()
//    private var requestsID = [Int]()
    
    
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
//        requests = [Int: WebSocketRequest]()
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

        // Handler

        
//        let requestId = 111 // randomUniqueId()
//
//        let request = WebSocketRequest(requestId:   requestId,
//                                       method:      method,
//                                       parameters:  parameters,
//                                       completion:  completion)
//
//        requests[requestId] = request

//        webSocket.isConnected ? sendMessage(request.messageString) : webSocket.connect()
    }

    
    /// DELETE AFTER TEST
    func sendRequestWith(method: WebSocketMethod,
                         parameters: Any,
                         completion: @escaping (Any?, NSError?) -> Void) {
//        Logger.log(message: "Success", event: .severe)

//        let requestId = 111 // randomUniqueId()
//
//        let request = WebSocketRequest(requestId:   requestId,
//                                       method:      method,
//                                       parameters:  parameters,
//                                       completion:  completion)
//
//        requests[requestId] = request
//
//        webSocket.isConnected ? sendMessage(request.messageString) : webSocket.connect()
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

    // DELETE AFTER TEST
//    func websocketDidConnect(socket: WebSocketClient) {
//        Logger.log(message: "Success", event: .severe)
//
//        guard requests.count > 0 else {
//            return
//        }
//
//        Logger.log(message: "requests = \(requests)", event: .debug)
//
//        for (_, request) in requests {
//            sendMessage(request.messageString)
//        }
//    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        Logger.log(message: "Success", event: .severe)

        guard let response = WebSocketResponse(withText: text) else {
            return
        }
        
        guard let requestApiStore = requestsApiStore[response.requestId] else {
            return
        }
        
        // Remove requestStore
        requestsApiStore[requestApiStore.type.id] = nil

        // Remove unique request ID
        if let requestID = requestIDs.index(of: response.requestId) {
            requestIDs.remove(at: requestID)
        }
        
        requestApiStore.completion((response: response.result as? [[String : Any]], error: response.error))
//        request.completion(response.result, response.error)
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
