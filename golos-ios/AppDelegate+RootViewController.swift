//
//  AppDelegate+RootViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

extension AppDelegate {
    func configureMainContainer() {
        let mainContainerViewController = MainContainerViewController()
        window?.rootViewController = mainContainerViewController
    }
}
