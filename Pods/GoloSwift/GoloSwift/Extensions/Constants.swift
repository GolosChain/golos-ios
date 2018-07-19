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

public enum AppBuildConfig: Int {
    case Development = 0
    case Debug
    case Release
}

// Dynamic values
// ResponseAPIDynamicGlobalProperty(id: 0, time: "2018-05-14T15:25:30", head_block_id: "00fad3ee54c33d7b5f62c3eca793cc3549ddfcc7", head_block_number: 16438254)
var headBlockNumber: UInt16             =   0
var headBlockID: UInt32                 =   0
var time: String                        =   ""

var chainID: String                     =   (appBuildConfig == AppBuildConfig.Release) ?    "782a3039b478c839e4cb0c941ff4eaeb7df40bdd68bd441afd444b9da763de12" :
                                                                                            "5876894a41e6361bde2e73278f07340f2eb8b41c2facd29099de9deef6cdb679"

public var appBuildConfig: AppBuildConfig      =   AppBuildConfig.Debug

// Websocket
public var webSocket                    =   WebSocket(url: URL(string: (appBuildConfig == AppBuildConfig.Debug) ? "wss://ws.golos.io" : "wss://ws.testnet.golos.io")!)
public let webSocketManager             =   WebSocketManager()

/// Websocket response max timeout, in seconds
public let webSocketTimeout             =   60.0
public let webSocketLimit: UInt         =   10

public let loadDataLimit: UInt          =   10
