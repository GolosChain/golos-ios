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
        self.startWithWelcomeScene = value
        self.save()
    }
    
    func setAppThemeDark(_ value: Bool) {
        ThemeManager.setTheme(index: value ? 1 : 0)
        self.isAppThemeDark = value

        self.save()
    }

    func setPushNotificationSoundOn(_ value: Bool) {
        self.isPushNotificationSoundOn = value
        self.save()
    }

    func setFeedShowImages(_ value: Bool) {
        self.isFeedShowImages = value
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
        self.language                   =   Locale.current.languageCode ?? "en"
        self.userNickName               =   User.current?.nickName ?? "Anonymous"
        self.isAppThemeDark             =   false
        self.isFeedShowImages           =   true
        self.isPushNotificationSoundOn  =   true
        self.startWithWelcomeScene      =   true

        ThemeManager.setTheme(index: 0)
        Localize.setCurrentLanguage(self.language)

        self.save()
    }
    
    func update(basic: ResponseAPIMicroserviceGetOptionsBasic) {
        self.setAppThemeDark(basic.theme == 0 ? false : true)
        self.setFeedShowImages(basic.feedShowImages == 0 ? false : true)
        self.setPushNotificationSoundOn(basic.soundOn == 0 ? false : true)
    }
    
    func update(push: ResponseAPIMicroserviceGetOptionsPush) {
        self.language                               =   push.lang
        self.isPushNotificationVote                 =   push.show.vote
        self.isPushNotificationFlag                 =   push.show.flag
        self.isPushNotificationTransfer             =   push.show.transfer
        self.isPushNotificationReply                =   push.show.reply
        self.isPushNotificationSubscribe            =   push.show.subscribe
        self.isPushNotificationUnsubscribe          =   push.show.unsubscribe
        self.isPushNotificationMention              =   push.show.mention
        self.isPushNotificationRepost               =   push.show.repost
        self.isPushNotificationAward                =   push.show.reward
        self.isPushNotificationCuratorAward         =   push.show.curatorReward
        self.isPushNotificationMessage              =   push.show.message
        self.isPushNotificationWitnessVote          =   push.show.witnessVote
        self.isPushNotificationWitnessCancelVote    =   push.show.witnessCancelVote
        
        self.isAllPushNotificationsOn   =   push.show.vote && push.show.flag && push.show.transfer && push.show.reply && push.show.subscribe && push.show.unsubscribe &&
            push.show.mention && push.show.repost && push.show.reward && push.show.curatorReward && push.show.message && push.show.witnessVote &&
                                                    push.show.witnessCancelVote

        self.save()
    }

    func updatePush(options: RequestParameterAPI.PushOptions) {
        self.language                               =   options.language
        self.isPushNotificationVote                 =   options.vote
        self.isPushNotificationFlag                 =   options.flag
        self.isPushNotificationTransfer             =   options.transfer
        self.isPushNotificationReply                =   options.reply
        self.isPushNotificationSubscribe            =   options.subscribe
        self.isPushNotificationUnsubscribe          =   options.unsubscribe
        self.isPushNotificationMention              =   options.mention
        self.isPushNotificationRepost               =   options.repost
        self.isPushNotificationAward                =   options.award
        self.isPushNotificationCuratorAward         =   options.curatorAward
        self.isPushNotificationMessage              =   options.message
        self.isPushNotificationWitnessVote          =   options.witnessVote
        self.isPushNotificationWitnessCancelVote    =   options.witnessCancelVote
        
        self.isAllPushNotificationsOn   =   options.vote && options.flag && options.transfer && options.reply && options.subscribe && options.unsubscribe &&
            options.mention && options.repost && options.award && options.curatorAward && options.message && options.witnessVote &&
            options.witnessCancelVote
        
        self.save()
    }
    
    func updatePushNotifications(property: String, value: Bool) {
        let propertyName = String(format: "isPushNotification%@", property.uppercaseFirst)

        if propertyName == "isPushNotificationVote"                     { self.isPushNotificationVote = value }
        else if propertyName == "isPushNotificationFlag"                { self.isPushNotificationFlag = value }
        else if propertyName == "isPushNotificationTransfer"            { self.isPushNotificationTransfer = value }
        else if propertyName == "isPushNotificationReply"               { self.isPushNotificationReply = value }
        else if propertyName == "isPushNotificationSubscribe"           { self.isPushNotificationSubscribe = value }
        else if propertyName == "isPushNotificationUnsubscribe"         { self.isPushNotificationUnsubscribe = value }
        else if propertyName == "isPushNotificationMention"             { self.isPushNotificationMention = value }
        else if propertyName == "isPushNotificationRepost"              { self.isPushNotificationRepost = value }
        else if propertyName == "isPushNotificationAward"               { self.isPushNotificationAward = value }
        else if propertyName == "isPushNotificationCuratorAward"        { self.isPushNotificationCuratorAward = value }
        else if propertyName == "isPushNotificationMessage"             { self.isPushNotificationMessage = value }
        else if propertyName == "isPushNotificationWitnessVote"         { self.isPushNotificationWitnessVote = value }
        else if propertyName == "isPushNotificationWitnessCancelVote"   { self.isPushNotificationWitnessCancelVote = value }
        
        self.save()
    }
    
    func updateAllPushNotifications(value: Bool) {
        self.isPushNotificationVote                 =   value
        self.isPushNotificationFlag                 =   value
        self.isPushNotificationTransfer             =   value
        self.isPushNotificationReply                =   value
        self.isPushNotificationSubscribe            =   value
        self.isPushNotificationUnsubscribe          =   value
        self.isPushNotificationMention              =   value
        self.isPushNotificationRepost               =   value
        self.isPushNotificationAward                =   value
        self.isPushNotificationCuratorAward         =   value
        self.isPushNotificationMessage              =   value
        self.isPushNotificationWitnessVote          =   value
        self.isPushNotificationWitnessCancelVote    =   value
        
        self.isAllPushNotificationsOn               =   value
        
        self.save()
    }
}
