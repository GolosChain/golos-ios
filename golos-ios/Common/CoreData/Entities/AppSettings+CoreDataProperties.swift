//
//  AppSettings+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 1/3/19.
//  Copyright © 2019 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var language: String
    @NSManaged public var userNickName: String
    @NSManaged public var isAppThemeDark: Bool
    @NSManaged public var isFeedShowImages: Bool
    @NSManaged public var startWithWelcomeScene: Bool

    // Push notifications properties
    @NSManaged public var isAllPushNotificationsOn: Bool
    @NSManaged public var isPushNotificationSoundOn: Bool

    @NSManaged public var isPushNotificationVote: Bool
    @NSManaged public var isPushNotificationFlag: Bool
    @NSManaged public var isPushNotificationTransfer: Bool
    @NSManaged public var isPushNotificationReply: Bool
    @NSManaged public var isPushNotificationSubscribe: Bool
    @NSManaged public var isPushNotificationUnsubscribe: Bool
    @NSManaged public var isPushNotificationMention: Bool
    @NSManaged public var isPushNotificationRepost: Bool
    @NSManaged public var isPushNotificationAward: Bool
    @NSManaged public var isPushNotificationCuratorAward: Bool
    @NSManaged public var isPushNotificationMessage: Bool
    @NSManaged public var isPushNotificationWitnessVote: Bool
    @NSManaged public var isPushNotificationWitnessCancelVote: Bool

}
