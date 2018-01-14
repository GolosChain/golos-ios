//
//  LoginPresenter.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol LoginView: class {
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
