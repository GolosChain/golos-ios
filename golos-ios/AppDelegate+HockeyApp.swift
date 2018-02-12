//
//  AppDelegate+HockeyApp.swift
//  Golos
//
//  Created by Grigory on 12/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import HockeySDK

extension AppDelegate {
    func setupHockeyApp() {
        let hockeyAppId = Bundle.main.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.hockeyAppIdKey) as! String
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppId)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        BITHockeyManager.shared().testIdentifier()
    }
}
