//
//  LoginPresenter.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol LoginView: ViewProtocol {
    func didStartLogin()
    func didLoginSuccessed()
}

class LoginPresenter: NSObject {
    weak var view: LoginView!
    
    var loginType = LoginType.postingKey {
        didSet {
            refreshUIStrings()
        }
    }
    var loginUIStrings: LoginUIStrings!
    
    override init() {
        super.init()
        refreshUIStrings()
    }
    
    func login(with login: String?,
               key: String?) {
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
    
    private func startLogin(with login: String,
                            key: String) {
        view.didStartLogin()
        
        let delayTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: delayTime) { [weak self] in
            guard let strongSelf = self else {return}
            
            DispatchQueue.main.async {
                strongSelf.view.didLoginSuccessed()
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
