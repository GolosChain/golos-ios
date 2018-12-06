//
//  Constants.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 12/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

enum LanguageSupport: String {
    case english    =   "English"
    case russian    =   "Russian"
}

enum GolosWebPage: String {
    case wiki           =   "https://wiki.golos.io/"
    case welcome        =   "https://golos.io/welcome"
    case registration   =   "https://reg.golos.io"
    case privacyPolicy  =   "https://golos.io/ru--konfidenczialxnostx/@golos/politika-konfidencialnosti"
}

struct ConstantsApp {
    struct ButtonParameters {
        static let cornerRadius: CGFloat = 22.0
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


// Amplitude exclusion list
let amplitudeExclusionList              =   ["joseph.kalu", "destroyer2k", "nick.lick", "qwe-rty", "piypiy", "satsat", "lol-lol", "d333", "wewe1", "zxcvbn"]


// Operation values
let voter: String                       =   "msm72"
let author: String                      =   "yuri-vlad-second"
let permlink: String                    =   "sdgsdgsdg234234"
let weight: Int64                       =   10_000

// iPhone 6, iPhone 8 as design template
let heightRatio: CGFloat                =   UIScreen.main.bounds.height / (UIApplication.shared.statusBarOrientation.isPortrait ? 667 : 375)
let widthRatio: CGFloat                 =   UIScreen.main.bounds.width / (UIApplication.shared.statusBarOrientation.isPortrait ? 375 : 667)

let cacheApp                            =   NSCache<NSString, UIImage>()

var isNetworkAvailable: Bool {
    set { }
    
    get {
        return ReachabilityManager.connection()
    }
}

let appVersion                          =   String(format: "%@.%@", Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String, Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
var selectedTabBarItem: Int             =   0


// Amplitude SDK
enum AmplitudeEvent: String {
    case like                           =   "ios_post_like_"
    case login                          =   "ios_login_"
    case dislike                        =   "ios_post_dislike_"
    case welcome                        =   "webview_ios_welcome_"
    case postCreate                     =   "ios_post_create_"
    case replyCreate                    =   "ios_reply_create_"
    case registration                   =   "webview_ios_registration_screen"
    case commentCreate                  =   "ios_comment_create_"
}
