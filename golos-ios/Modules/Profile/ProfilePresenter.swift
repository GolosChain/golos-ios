//
//  ProfilePresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ProfilePresenter: NSObject {
    let stateMachine = StateMachine.load()
    
    func logout() {
        stateMachine.changeState(.loggedOut)
    }
}
