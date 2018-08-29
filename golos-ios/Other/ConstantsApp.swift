//
//  Constants.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 12/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift
import CoreData

enum LanguageSupport: String {
    case english    =   "English"
    case russian    =   "Russian"
}

struct ConstantsApp {
    struct ButtonParameters {
        static let cornerRadius: CGFloat = 22.0
    }
    
    struct Urls {
        static let moreInfoAbout        =   "https://golos.io/welcome"
        static let registration         =   "https://golos.io/create_account"
    }
    
    struct StateMachine {
        static let oldStateKey          =   "oldStateKey"
    }
}

let broadcast: Broadcast                =   Broadcast.shared


// Firebase
// https://console.firebase.google.com/u/0/project/golos-5b0d5/settings/cloudmessaging/ios:io.golos.testing.golos-ios
let gcmMessageIDKey                     =  "gcm.message_id"
//"AAAAcjPaNzY:APA91bGce4gHFXIsVTWIlLyZZA2HI0aVo8Mh_y8jF8Tu9gPyBM02G0WZtkXQXjfXmWLOrjhb9f6a50gxryPOEzKwBhy0q49OcAj5k_qP6YPqmLsYHC0jFqXZdKQ9CUShA6n2LumOe1s8"

// Init Messaging manager
let fcm                                 =   FCManager.init(withTopics: ["msm72", "sergiy"])


// Operation values
let voter: String                       =   "msm72"
let author: String                      =   "yuri-vlad-second"
let permlink: String                    =   "sdgsdgsdg234234"
let weight: Int64                       =   10_000

// iPhone 6, iPhone 8 as design template
let heightRatio: CGFloat                =   UIScreen.main.bounds.height / (UIApplication.shared.statusBarOrientation.isPortrait ? 667 : 375)
let widthRatio: CGFloat                 =   UIScreen.main.bounds.width / (UIApplication.shared.statusBarOrientation.isPortrait ? 375 : 667)

let cacheApp                            =   NSCache<NSString, UIImage>()

var isAppThemeDark: Bool {
    set { }
    
    get {
        return UserDefaults.standard.object(forKey: appThemeKey) as? Bool ?? false
    }
}

var isNetworkAvailable: Bool {
    set { }
    
    get {
        return ReachabilityManager.connection()
    }
}

let appVersion                          =   Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String


// Keys
let appThemeKey                         =   "AppTheme"
let userStateKey                        =   "UserState"
