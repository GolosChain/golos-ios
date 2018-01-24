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
            return UIImage.init(named: "profile_edit_button_icon")!
        }
        
        static func getSettingsButtonImage() -> UIImage {
            return UIImage.init(named: "profile_settings_button_icon")!
        }
        
        static func getProfileHeaderBackground() -> UIImage {
            return UIImage.init(named: "profile_header_bg")!
        }
    }
}
