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
    static let shared = WebSocketManager()
    
    private var requests = [Int: WebSocketRequest]()
    
    var usedRequestIds = [Int]()
    
    lazy var webSocket: WebSocket = {
        let infoDictionary = Bundle.main.infoDictionary!
        let webSocketUrlString = infoDictionary[Constants.InfoDictionaryKey.webSocketUrlKey] as! String
        let webSocketUrl = URL(string: webSocketUrlString)!
    
        let webSocket = WebSocket(url: webSocketUrl)
        webSocket.delegate = self
       
        return webSocket
    }()
    
    func connect() {
        if webSocket.isConnected { return }
        webSocket.connect()
    }
    
    func disconnect() {
        if !webSocket.isConnected { return }
        requests = [Int: WebSocketRequest]()
        usedRequestIds = [Int]()
        webSocket.disconnect()
    }
    
    func sendMessage(_ message: String) {
        webSocket.write(string: message)
    }
    
    func sendRequestWith(method: WebSocketMethod,
                         parameters: Any,
                         completion: @escaping (Any?, NSError?) -> Void) {
        
        let requestId = randomUniqueId()
        let request = WebSocketRequest(requestId: requestId,
                                       method: method,
                                       parameters: parameters,
                                       completion: completion)
        
        requests[requestId] = request
        
        if webSocket.isConnected {
            sendMessage(request.messageString)
        } else {
            webSocket.connect()
        }
    }
}

extension WebSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Websocket did connect")
        guard requests.count > 0 else {
            return
        }
        
        for (_, request) in requests {
            sendMessage(request.messageString)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Websocket did disconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let response = WebSocketResponse(responseText: text) else {
            return
        }
        
        guard let request = requests[response.requestId] else {
            return
        }
        
        requests[response.requestId] = nil
        if let idIndex = usedRequestIds.index(of: response.requestId) {
            usedRequestIds.remove(at: idIndex)
        }
        
        request.completion(response.result, response.error)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}


// Temprorary !!!
extension WebSocketManager {
    func randomUniqueId() -> Int {
        var generatedId = 0
        repeat {
            generatedId = Int(arc4random_uniform(1000))
        } while usedRequestIds.contains(generatedId)
        
        usedRequestIds.append(generatedId)
        
        return generatedId
    }
}
