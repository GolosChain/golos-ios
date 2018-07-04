//
//  ProfilePresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

protocol ProfilePresenterProtocol: class {
    func setUsername(username: String?)
    // TODO: Remove userModel from presenter when add local cache
    func setUser(_ userModel: DisplayedUser?)
    
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
    // MARK: - View
    weak var profileView: ProfileViewProtocol!
    
    private var user: DisplayedUser? {
        didSet {
            if let user = user {
                self.viewModel = ProfileViewModel(userModel: user)
            }
        }
    }
    
    private var username: String?
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
    
    func setUser(_ userModel: DisplayedUser?) {
        self.user = userModel
    }
    
    func getProfileViewModel() -> ProfileViewModel? {
        return viewModel
    }
    
    func fetchUser() {
        profileView.didRefreshUser()
    }
    
    /// API
    func loadUser() {
        // TODO: - RECOMMENT AFTER CREATE USER MODEL
//        guard let userName = self.username else {
//            return
//        }
        
//        let userName = "msm72"
        let userName = "yuri-vlad-second"

        userManager.loadUsers(byNames: [userName]) { [weak self] (displayedUsers, errorAPI) in
            guard let strongSelf = self else { return }

            guard errorAPI == nil else {
                return
            }
            
            guard let user = displayedUsers?.first else {
                strongSelf.profileView.didFail(with: "User is not found")
                return
            }
            
            // Prepare & Display user
            strongSelf.user = user
            strongSelf.profileView.didRefreshUser()
        }
    }
}
