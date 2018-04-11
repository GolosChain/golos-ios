//
//  ProfilePresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfilePresenterProtocol: class {
    func setUsername(username: String?)
    // TODO: Remove userModel from presenter when add local cache
    func setUser(_ userModel: UserModel?)
    
    func getProfileViewModel() -> ProfileViewModel?
    func fetchUser()
    func loadUser()
    func logout()
}

protocol ProfileViewProtocol: class {
    func didRefreshUser()
    func didFail(with errorMessage: String)
}

class ProfilePresenter: NSObject {
    // MARK: View
    weak var profileView: ProfileViewProtocol!
    
    private var username: String?
    private var user: UserModel? {
        didSet {
            if let user = user {
                self.viewModel = ProfileViewModel(userModel: user)
            }
        }
    }
    
    private var viewModel: ProfileViewModel?
    
    private var userManager = UserManager()
    
    override init() {
        super.init()
    }
    
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func logout() {
        StateMachine.load().changeState(.loggedOut)
    }
    
    func setUsername(username: String?) {
        self.username = username
    }
    
    func setUser(_ userModel: UserModel?) {
        self.user = userModel
    }
    
    func getProfileViewModel() -> ProfileViewModel? {
        return viewModel
    }
    
    func fetchUser() {
        profileView.didRefreshUser()
    }
    
    func loadUser() {
        guard let username = self.username else {
            return
        }
        
        userManager.loadUser(with: username) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                Logger.log(message: "\(error!.localizedDescription)", event: .error)
                strongSelf.profileView.didFail(with: error!.localizedDescription)
                return
            }
            
            guard let user = user else {
                return
            }
            
            strongSelf.user = user
            strongSelf.profileView.didRefreshUser()
        }
    }
}
