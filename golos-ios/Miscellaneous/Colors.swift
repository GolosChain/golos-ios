//
//  Colors.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 12/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    struct Project {
        static let buttonBgBlue = UIColor(red: 18, green: 152, blue: 255)
        static let buttonTextWhite = UIColor(red: 255, green: 255, blue: 255)
        static let buttonTextGray = UIColor(red: 125, green: 125, blue: 125)
        static let buttonBorderGray = UIColor(red: 219, green: 219, blue: 219)
        static let textBlack = UIColor(red: 51, green: 51, blue: 51)
        static let textPlaceholderGray = UIColor(red: 125, green: 125, blue: 125)
        static let navigationBarTextBlack = UIColor(red: 45, green: 41, blue: 41)
        static let backButtonBlackColor = UIColor(red: 60, green: 54, blue: 54)
        static let darkBlueTabSelected = UIColor(red: 68, green: 105, blue: 175)
        static let darkBlueHeader = UIColor(red: 68, green: 105, blue: 175)
        
        //MARK: Horizontal selector
        static let unselectedButtonColor = UIColor(red: 214, green: 214, blue: 214)
        
        //MARK: Article
        static let articleBlackColor = UIColor(red: 51, green: 51, blue: 51)
        static let articleBodyGrayColor = UIColor(red: 79, green: 79, blue: 79)
        static let articleButtonsGreenColor = UIColor(red: 106, green: 211, blue: 129)
        static let articleButtonsGrayColor = UIColor(red: 193, green: 193, blue: 193)
        
        //MARK: Profile
        static let profileSelectionViewBackground = UIColor(red: 18, green: 152, blue: 255)
        
        struct TagToken {
            static let textColor = UIColor(red: 130, green: 130, blue: 130)
            static let borderColor = UIColor(red: 224, green: 224, blue: 224)
        }
    }
}
