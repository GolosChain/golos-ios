//
//  Images.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 23/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

struct Images {
    struct Profile {
        static func getEditProfileButtonImage() -> UIImage {
            return UIImage.init(named: "icon-button-edit-white-normal")!
        }
        
        static func getSettingsButtonImage() -> UIImage {
            return UIImage.init(named: "icon-user-profile-settings-black")!
        }
        
        static func getProfileHeaderBackground() -> UIImage {
            return UIImage.init(named: "image-user-cover-placeholder-old")!
        }
    }
}
