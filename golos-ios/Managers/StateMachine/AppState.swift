//
//  AppState.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

enum AppState: String {
    case loggedOut
    case loggedIn
    
    var isLoggedOut: Bool {
        return self == AppState.loggedOut
    }
    
    var isLoggedIn: Bool {
        return self == AppState.loggedIn
    }
}
