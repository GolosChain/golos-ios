//
//  ProfilePresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfilePresenterProtocol: class {
    func refresh()
}

protocol ProfileViewProtocol: class {
    func didRefreshSuccess()
}

class ProfilePresenter: NSObject {
    //MARK: View
    weak var profileView: ProfileViewProtocol!
    
    let stateMachine = StateMachine.load()
    
    func logout() {
        stateMachine.changeState(.loggedOut)
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.profileView.didRefreshSuccess()
        }
    }
}
