//
//  AppSettings+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 05.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation
import SwiftTheme
import Localize_Swift

@objc(AppSettings)
public class AppSettings: NSManagedObject {
    // MARK: - Properties
    static let settingsPredicate = NSPredicate(format: "userNickName == %@", User.current?.nickName ?? "Anonymous")
    
    class var isAppThemeDark: Bool {
        get {
            return (CoreDataManager.instance.readEntities(withName:                     "AppSettings",
                                                          withPredicateParameters:      settingsPredicate,
                                                          andSortDescriptor:            nil)?.first as! AppSettings).isAppThemeDark
        }
    }
    
    class var isFeedShowImages: Bool {
        get {
            return (CoreDataManager.instance.readEntities(withName:                     "AppSettings",
                                                          withPredicateParameters:      settingsPredicate,
                                                          andSortDescriptor:            nil)?.first as! AppSettings).isFeedShowImages
        }
    }

    class var startWithWelcomeScene: Bool {
        get {
            return (CoreDataManager.instance.readEntities(withName:                     "AppSettings",
                                                          withPredicateParameters:      settingsPredicate,
                                                          andSortDescriptor:            nil)?.first as! AppSettings).startWithWelcomeScene
        }
    }

    class var isAllPushNotificationsOn: Bool {
        get {
            return (CoreDataManager.instance.readEntities(withName:                     "AppSettings",
                                                          withPredicateParameters:      settingsPredicate,
                                                          andSortDescriptor:            nil)?.first as! AppSettings).isAllPushNotificationsOn
        }
    }
    
    class var isPushNotificationSoundOn: Bool {
        get {
            return (CoreDataManager.instance.readEntities(withName:                     "AppSettings",
                                                          withPredicateParameters:      settingsPredicate,
                                                          andSortDescriptor:            nil)?.first as! AppSettings).isPushNotificationSoundOn
        }
    }

    
    // MARK: - Class Functions
    class func instance() -> AppSettings {
        if let appSettings = CoreDataManager.instance.readEntity(withName: "AppSettings", andPredicateParameters: settingsPredicate) as? AppSettings {
            ThemeManager.setTheme(index: appSettings.isAppThemeDark ? 1 : 0)
            return appSettings
        }
        
        else {
            let appSettings = CoreDataManager.instance.createEntity("AppSettings") as! AppSettings
            appSettings.setup()
            
            return appSettings
        }
    }
    
    
    // MARK: - Custom Functions
    func setStartWithWelcomeScene(_ value: Bool) {
        self.startWithWelcomeScene  =   value
        self.save()
    }
    
    func setAppThemeDark(_ value: Bool) {
        ThemeManager.setTheme(index: value ? 1 : 0)
        self.isAppThemeDark         =   value

        self.save()
    }

    func setFeedShowImages(_ value: Bool) {
        self.isFeedShowImages       =   value
        self.save()
    }

    func setAllPushNotificationsOn(value: Bool) {
        self.isAllPushNotificationsOn = value
        self.save()
    }

    func setPushNotificationSoundOn(value: Bool) {
        self.isPushNotificationSoundOn = value
        self.save()
    }

    func setup() {
        self.language               =   Locale.current.languageCode ?? "en"
        self.userNickName           =   User.current?.nickName ?? "Anonymous"
        self.isAppThemeDark         =   false
        self.isFeedShowImages       =   true
        self.startWithWelcomeScene  =   true

        ThemeManager.setTheme(index: 0)
        Localize.setCurrentLanguage(self.language)

        self.save()
    }
    
    func update(basic: ResponseAPIMicroserviceGetOptionsBasic) {
        self.setAppThemeDark(basic.theme == 0 ? false : true)
        self.setFeedShowImages(basic.feedShowImages == 0 ? false : true)
    }
    
    func update(push: ResponseAPIMicroserviceGetOptionsPush) {
        self.language                           =   push.lang
        self.isNotificaionPushVote              =   push.show.vote
        self.isNotificaionPushFlag              =   push.show.flag
        self.isNotificaionPushTransfer          =   push.show.transfer
        self.isNotificaionPushReply             =   push.show.reply
        self.isNotificaionPushSubscribe         =   push.show.subscribe
        self.isNotificaionPushUnsubscribe       =   push.show.unsubscribe
        self.isNotificaionPushMention           =   push.show.mention
        self.isNotificaionPushRepost            =   push.show.repost
        self.isNotificaionPushReward            =   push.show.award
        self.isNotificaionPushCuratorReward     =   push.show.curatorAward
        self.isNotificaionPushMessage           =   push.show.message
        self.isNotificaionPushWitnessVote       =   push.show.witnessVote
        self.isNotificaionPushWitnessCancelVote =   push.show.witnessCancelVote
        
        self.isAllPushNotificationsOn           =   push.show.vote && push.show.flag && push.show.transfer && push.show.reply && push.show.subscribe && push.show.unsubscribe &&
                                                    push.show.mention && push.show.repost && push.show.award && push.show.curatorAward && push.show.message && push.show.witnessVote &&
                                                    push.show.witnessCancelVote

        self.save()
    }

    func updatePushNotifications(property: String, value: Bool) {
        let propertyName = String(format: "isNotificaion%@%@", "Push", property.uppercaseFirst)

        if propertyName == "isNotificaionPushVote"                      { self.isNotificaionPushVote = value }
        else if propertyName == "isNotificaionPushFlag"                 { self.isNotificaionPushFlag = value }
        else if propertyName == "isNotificaionPushTransfer"             { self.isNotificaionPushTransfer = value }
        else if propertyName == "isNotificaionPushReply"                { self.isNotificaionPushReply = value }
        else if propertyName == "isNotificaionPushSubscribe"            { self.isNotificaionPushSubscribe = value }
        else if propertyName == "isNotificaionPushUnsubscribe"          { self.isNotificaionPushUnsubscribe = value }
        else if propertyName == "isNotificaionPushMention"              { self.isNotificaionPushMention = value }
        else if propertyName == "isNotificaionPushRepost"               { self.isNotificaionPushRepost = value }
        else if propertyName == "isNotificaionPushReward"               { self.isNotificaionPushReward = value }
        else if propertyName == "isNotificaionPushCuratorReward"        { self.isNotificaionPushCuratorReward = value }
        else if propertyName == "isNotificaionPushMessage"              { self.isNotificaionPushMessage = value }
        else if propertyName == "isNotificaionPushWitnessVote"          { self.isNotificaionPushWitnessVote = value }
        else if propertyName == "isNotificaionPushWitnessCancelVote"    { self.isNotificaionPushWitnessCancelVote = value }
        
        self.save()
    }
    
    func updateAllPushNotifications(value: Bool) {
        self.isNotificaionPushVote                  =   value
        self.isNotificaionPushFlag                  =   value
        self.isNotificaionPushTransfer              =   value
        self.isNotificaionPushReply                 =   value
        self.isNotificaionPushSubscribe             =   value
        self.isNotificaionPushUnsubscribe           =   value
        self.isNotificaionPushMention               =   value
        self.isNotificaionPushRepost                =   value
        self.isNotificaionPushReward                =   value
        self.isNotificaionPushCuratorReward         =   value
        self.isNotificaionPushMessage               =   value
        self.isNotificaionPushWitnessVote           =   value
        self.isNotificaionPushWitnessCancelVote     =   value
        
        self.isAllPushNotificationsOn               =   value
        
        self.save()
    }
}
