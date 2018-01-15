//
//  StateMachine.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class StateMachine {
    static let appStateKey = "appStateKey"
    
    var userDefaults: UserDefaults!
    
    var state: AppState {
        return getCurrentState()
    }
    
    class func load(_ userDefaults: UserDefaults = UserDefaults.standard) -> StateMachine {
        let stateMachine = StateMachine(with: userDefaults)
        return stateMachine
    }
    
    // Life cycle
    private init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    
    // States
    func changeState(_ state: AppState) {
        let currentState = self.state
        let isValid = isValidState(state)
        
        assert(isValid == true, "Cant change state to: \(state) from: \(currentState)")
        
        userDefaults.set(state.rawValue, forKey: StateMachine.appStateKey)
        NotificationCenter.default.post(name: NSNotification.Name.appStateChanged,
                                        object: nil,
                                        userInfo: [Constants.StateMachine.oldStateKey: currentState])
        print("State changed notification sent")
    }
    
    private func getCurrentState() -> AppState {
        var state = AppState.loggedOut
        
        if let cachedStateRaw = userDefaults.string(forKey: StateMachine.appStateKey),
            let cachedState = AppState(rawValue: cachedStateRaw) {
            state = cachedState
        }
        
        return state
    }
    
    func isValidState(_ state: AppState) -> Bool {
        if state == self.state {
            return true
        }
        
        let isValid: Bool
        switch self.state {
        case .loggedIn:
            isValid = isStateValidAfterLoggedIn(state)
        case .loggedOut:
            isValid = isStateValidAfterLoggedOut(state)
        }
        
        return isValid
    }
    
    private func isStateValidAfterLoggedOut(_ state: AppState) -> Bool {
        return state.isLoggedIn
    }
    
    private func isStateValidAfterLoggedIn(_ state: AppState) -> Bool {
        return state.isLoggedOut
    }
}
