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
//        // UITabBar and UITabBarItem
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: FontManager.shared.ralewayRegular(withSize: 11)],
//                                                         for: .normal)
//        UITabBar.appearance().barTintColor = UIColor.black
//        UITabBar.appearance().tintColor = UIColor.white
//    }
}
