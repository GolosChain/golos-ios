//
//  Constants.swift
//  GoloSwift
//
//  Created by msm72 on 07.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//
//  https://golos.io/test/@yuri-vlad-second/sdgsdgsdg234234

import Foundation
import Starscream

public enum AppBuildConfig: String {
    case debug          =   "Debug"
    case release        =   "Release"
    
    // For Testnet
    case development    =   "Development"
}

/// App Scheme
public let appBuildConfig   =   AppBuildConfig.init(rawValue: (Bundle.main.infoDictionary?["Config"] as? String)!.replacingOccurrences(of: "\\", with: ""))


/// Websocket
public var webSocketBlockchain      =   WebSocket(url: URL(string: (appBuildConfig == AppBuildConfig.development) ? "wss://ws.testnet.golos.io" : "wss://ws.golos.io")!)
public var webSocketMicroservices   =   WebSocket(url: URL(string: "wss://gate.golos.io")!)

public let imagesURL: String        =   "https://images.golos.io"


/// Websocket response max timeout, in seconds
public let loadDataLimit: UInt      =   10
public let webSocketLimit: UInt     =   10
public let webSocketTimeout         =   60.0
