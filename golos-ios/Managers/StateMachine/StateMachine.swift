//
//  StateMachine.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

class StateMachine {
    // MARK: - Properties
    static let appStateKey = "appStateKey"
    var userDefaults: UserDefaults!
    
    var state: AppState {
        return getCurrentState()
    }
    
    
    // MARK: - Class Initialization
    private init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Custom Functions
    class func load(_ userDefaults: UserDefaults = UserDefaults.standard) -> StateMachine {
        let stateMachine = StateMachine(with: userDefaults)
        return stateMachine
    }
    
    func changeState(_ state: AppState) {
        Logger.log(message: "Success", event: .severe)

        let currentState = self.state
        let isValid = isValidState(state)
        
        assert(isValid == true, "Cant change state to: \(state) from: \(currentState)")
        
        userDefaults.set(state.rawValue, forKey: StateMachine.appStateKey)
       
        NotificationCenter.default.post(name: NSNotification.Name.appStateChanged,
                                        object: nil,
                                        userInfo: [ConstantsApp.StateMachine.oldStateKey: currentState])
       
        Logger.log(message: "State changed notification sent", event: .info)
    }
    
    private func getCurrentState() -> AppState {
        Logger.log(message: "Success", event: .severe)

        var state = AppState.loggedOut
        
        if let cachedStateRaw = userDefaults.string(forKey: StateMachine.appStateKey),
            let cachedState = AppState(rawValue: cachedStateRaw) {
            state = cachedState
        }
        
        return state
    }
    
    func isValidState(_ state: AppState) -> Bool {
        Logger.log(message: "Success", event: .severe)

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
        Logger.log(message: "Success", event: .severe)

        return state.isLoggedIn
    }
    
    private func isStateValidAfterLoggedIn(_ state: AppState) -> Bool {
        Logger.log(message: "Success", event: .severe)

        return state.isLoggedOut
    }
}
