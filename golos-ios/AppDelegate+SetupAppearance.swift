//
//  AppDelegate+SetupAppearance.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension AppDelegate {
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = .white
        appearance.tintColor = UIColor.Project.backButtonBlackColor
        appearance.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.Project.navigationBarTextBlack,
            NSAttributedStringKey.font: Fonts.shared.regular(with: 16.0)
        ]
        appearance.isTranslucent = false
        appearance.shadowImage = UIImage()
    }
    
    func setupTabBarAppearance() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.Project.darkBlueTabSelected
        UITabBar.appearance().isTranslucent = false
    }
}
