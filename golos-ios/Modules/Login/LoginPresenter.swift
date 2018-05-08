//
//  LoginPresenter.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Locksmith

protocol LoginView: ViewProtocol {
    func didStartLogin()
    func didLoginSuccessed()
}

class LoginPresenter: NSObject {
    // MARK: - Properties
    weak var view: LoginView!
    var loginUIStrings: LoginUIStrings!
    let stateMachine = StateMachine.load()

    var loginType = LoginType.postingKey {
        didSet {
            refreshUIStrings()
        }
    }
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
        refreshUIStrings()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Custom Functions
    func login(with login: String?, key: String?) {
        var errorMessage: String?
        
        defer {
            if let errorMessage = errorMessage {
                view.didFail(with: errorMessage)
            } else {
                startLogin(with: login!, key: key!)
            }
        }
        
        if !validate(login: login) {
            errorMessage = "Введите корректный логин"
            return
        }
        
        if !validate(key: key) {
            errorMessage = "Введите корректный ключ"
            return
        }
    }
    
    func changeStateToLoggedIn() {
        stateMachine.changeState(.loggedIn)
    }
    
    private func startLogin(with login: String, key: String) {
        view.didStartLogin()
        
        // Delete stored data from Keychain
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "UserDataInfo")
            Logger.log(message: "Successfully delete Login data from Keychain.", event: .severe)
        } catch {
            Logger.log(message: "Delete Login data from Keychain error.", event: .error)
        }

        let delayTime = DispatchTime.now() + .seconds(1)
       
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: delayTime) { [weak self] in
            guard let strongSelf = self else {return}
            
            DispatchQueue.main.async {
                strongSelf.view.didLoginSuccessed()
                
                // Save login data to Keychain
                do {
                    try Locksmith.saveData(data: [ "login": login, "secretKey": key], forUserAccount: "UserDataInfo")
                    Logger.log(message: "Successfully save Login data to Keychain.", event: .severe)
                } catch {
                    Logger.log(message: "Save Login data to Keychain error.", event: .error)
                }
            }
        }
    }
    
    private func validate(login: String?) -> Bool {
        return Validator.validate(login: login)
    }
    
    private func validate(key: String?) -> Bool {
        return Validator.validate(key: key)
    }
    
    private func refreshUIStrings() {
        loginUIStrings = getLoginUIStrings(forType: loginType)
    }
}


//Login UI strings
extension LoginPresenter {
    private func getLoginUIStrings(forType type: LoginType) -> LoginUIStrings {
        switch type {
        case .activeKey:
            return getLoginUIStringsForActiveKey()
        case .postingKey:
            return getLoginUIStringsForPostingKey()
        }
    }
    
    private func getLoginUIStringsForActiveKey() -> LoginUIStrings {
        return LoginUIStrings(keyPlaceholder: "Ваш активный ключ",
                              loginTypeString: "Войти через постинг ключ",
                              titleString: "Войти с активным ключем")
    }
    
    private func getLoginUIStringsForPostingKey() -> LoginUIStrings {
        return LoginUIStrings(keyPlaceholder: "Приватный постинг ключ",
                              loginTypeString: "Войти с активным ключем",
                              titleString: "Войти")
    }
}
