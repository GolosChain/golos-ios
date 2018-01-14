//
//  Validator.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class Validator {
    class func validate(login: String?) -> Bool {
        guard let login = login, login.count > 0 else {
            return false
        }
        return true
    }
    
    class func validate(key: String?) -> Bool {
        guard let key = key, key.count > 0 else {
            return false
        }
        return true
    }
}
