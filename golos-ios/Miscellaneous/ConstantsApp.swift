//
//  Constants.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 12/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Starscream

//import CoreGraphics

struct ConstantsApp {
    struct ButtonParameters {
        static let cornerRadius: CGFloat = 22.0
    }
    
    struct Urls {
        static let moreInfoAbout    =   "https://golos.io/welcome"
        static let registration     =   "https://golos.io/create_account"
    }
    
    struct StateMachine {
        static let oldStateKey      =   "oldStateKey"
    }
    
    struct InfoDictionaryKey {
        static let webSocketUrlKey  =   "WebSocketUrl"
    }
}

let webSocketLimit      =   10

/// Websocket response max timeout, in seconds
let webSocketTimeout    =   60.0
