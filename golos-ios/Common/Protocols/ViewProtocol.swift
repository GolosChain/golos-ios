//
//  ViewProtocol.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol ViewProtocol: class {
    func didFail(with errorMessage: String)
    func stopAllActivity()
}

extension ViewProtocol {
    func didFail(with errorMessage: String) {
        stopAllActivity()
        Utils.showAlert(title: "Ошибка", message: errorMessage)
    }
    
    func stopAllActivity() {}
}
