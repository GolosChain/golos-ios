//
//  FCManager.swift
//  Golos
//
//  Created by msm72 on 26.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift
import FirebaseMessaging

class FCManager: NSObject {
    // MARK: - Properties
    var topics: [String]
    
    
    // MARK: - Class Initialization
    init(withTopics topics: [String]) {
        self.topics = topics

        super.init()
        
        Messaging.messaging().delegate = self
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    func register(deviceToken: Data) {
        let type: MessagingAPNSTokenType

        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        Logger.log(message: "\nAPNs device token:\n\t\(token)", event: .severe)
        
        #if DEBUG
            type = .sandbox
        #else
            type = .prod
        #endif
        
        Messaging.messaging().setAPNSToken(deviceToken, type: type)
        
        self.subscribeToTopics()
    }
    
    /// Firebase Cloud Messaging: subscribe to topics
    func subscribeToTopics() {
        // Subscribe to FCM Topics
        // https://firebase.google.com/docs/cloud-messaging/ios/topic-messaging
        // https://medium.com/developermind/using-firebase-cloud-messaging-for-remote-notifications-in-ios-d35de1dc67b2
        for topicName in topics {
            Messaging.messaging().subscribe(toTopic: "/topics/\(topicName)", completion: { error in
                guard error == nil else {
                    Logger.log(message: error!.localizedDescription, event: .error)
                    return
                }
                
                Logger.log(message: "Subscription to the topic \"\(topicName)\" has been successfully completed", event: .debug)
            })
        }
    }
    
    /// After User log out
    func unsubscribeFromTopics() {
        Messaging.messaging().unsubscribe(fromTopic: "/topics/msm72")
    }
    
    func refreshSubscriptions() {
        self.unsubscribeFromTopics()
        self.subscribeToTopics()
    }
}


// MARK: - MessagingDelegate
extension FCManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        self.refreshSubscriptions()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Logger.log(message: "Received Firebase token: \(fcmToken)", event: .debug)
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        Logger.log(message: "Received Remote message: \(remoteMessage.appData)", event: .debug)
    }
    
    // For iOS 10
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        Logger.log(message: "Received Remote message: \(remoteMessage.appData)", event: .debug)
    }
}
