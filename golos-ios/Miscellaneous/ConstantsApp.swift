//
//  Constants.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 12/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

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
}

let broadcast: Broadcast            =   Broadcast.shared



// Operation values
let voter: String                       =   "msm72"
let author: String                      =   "yuri-vlad-second"
let permlink: String                    =   "sdgsdgsdg234234"
let weight: Int64                       =   10_000
