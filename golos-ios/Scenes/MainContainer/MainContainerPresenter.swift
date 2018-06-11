//
//  MainContainerPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol MainContainerView: class {
    func didChange(newState: AppState, from oldState: AppState)
}

class MainContainerPresenter: NSObject {
    let stateMachine = StateMachine.load()
    
    var currentState: AppState {
        return stateMachine.state
    }
    
    // MARK: Module
    weak var view: MainContainerView!
    
    // MARK: Life cycle
    override init() {
        super.init()
        subscribeNotifications()
    }
    
    deinit {
        unsubscribeNotifications()
    }
    
    
    // MARK: Notifications
    func subscribeNotifications() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(stateDidChange(_:)),
//                                               name: NSNotification.Name.appStateChanged,
//                                               object: nil)
    }
    
    func unsubscribeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func stateDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let oldState = userInfo[ConstantsApp.StateMachine.oldStateKey] as? AppState else {
                return
        }
        
        view?.didChange(newState:   stateMachine.state,
                        from:       oldState)
    }
}
