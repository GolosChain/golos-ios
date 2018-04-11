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
//    static let shared = WebSocketManager()
    private var requests = [Int: WebSocketRequest]()
    var usedRequestIds = [Int]()
    
//    lazy var webSocket333: WebSocket = {
//        let infoDictionary = Bundle.main.infoDictionary!
//        Logger.log(message: "infoDictionary = \(infoDictionary)", event: .debug)
//        let webSocketUrlString = infoDictionary[Constants.InfoDictionaryKey.webSocketUrlKey] as! String
//        let webSocketUrl = URL(string: webSocketUrlString)!
//
//        let webSocket = WebSocket(url: webSocketUrl)
//        webSocket.delegate = self
//
//        return webSocket
//    }()
    
    
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
        
        requests = [Int: WebSocketRequest]()
        usedRequestIds = [Int]()
       
        webSocket.disconnect()
    }
    
    func sendMessage(_ message: String) {
        Logger.log(message: "Success", event: .severe)
        webSocket.write(string: message)
    }
    
    func sendRequestWith(method: WebSocketMethod,
                         parameters: Any,
                         completion: @escaping (Any?, NSError?) -> Void) {
        Logger.log(message: "Success", event: .severe)

        let requestId = 111 // randomUniqueId()
        
        let request = WebSocketRequest(requestId:   requestId,
                                       method:      method,
                                       parameters:  parameters,
                                       completion:  completion)
        
        requests[requestId] = request
        
        webSocket.isConnected ? sendMessage(request.messageString) : webSocket.connect()
    }
}


// MARK: - WebSocketDelegate
extension WebSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        Logger.log(message: "Success", event: .severe)

        guard requests.count > 0 else {
            return
        }
        
        Logger.log(message: "requests = \(requests)", event: .debug)
        
        for (_, request) in requests {
            sendMessage(request.messageString)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        Logger.log(message: "Success", event: .severe)

        guard let response = WebSocketResponse(withText: text) else {
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
    
    // Not used
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        Logger.log(message: "Success", event: .severe)
        
        self.disconnect()
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        Logger.log(message: "Success", event: .severe)
    }
}

//
//// Temprorary !!!
//extension WebSocketManager {
//    func randomUniqueId() -> Int {
//        Logger.log(message: "Success", event: .severe)
//        var generatedId = 0
//
//        repeat {
//            generatedId = Int(arc4random_uniform(1000))
//        } while usedRequestIds.contains(generatedId)
//
//        usedRequestIds.append(generatedId)
//
//        return generatedId
//    }
//}
