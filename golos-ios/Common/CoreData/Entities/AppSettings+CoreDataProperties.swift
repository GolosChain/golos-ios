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
    @NSManaged public var isPushNotificationSoundOn: Bool
    @NSManaged public var isOnlineNotificationSoundOn: Bool
    @NSManaged public var isAllPushNotificationsOn: Bool
    @NSManaged public var isAllOnlineNotificationsOn: Bool

    // Online notifications properties
    @NSManaged public var isNotificaionOnlineVote: Bool
    @NSManaged public var isNotificaionOnlineFlag: Bool
    @NSManaged public var isNotificaionOnlineTransfer: Bool
    @NSManaged public var isNotificaionOnlineReply: Bool
    @NSManaged public var isNotificaionOnlineSubscribe: Bool
    @NSManaged public var isNotificaionOnlineUnsubscribe: Bool
    @NSManaged public var isNotificaionOnlineMention: Bool
    @NSManaged public var isNotificaionOnlineRepost: Bool
    @NSManaged public var isNotificaionOnlineReward: Bool
    @NSManaged public var isNotificaionOnlineCuratorReward: Bool
    @NSManaged public var isNotificaionOnlineMessage: Bool
    @NSManaged public var isNotificaionOnlineWitnessVote: Bool
    @NSManaged public var isNotificaionOnlineWitnessCancelVote: Bool

    // Push notifications properties
    @NSManaged public var isNotificaionPushVote: Bool
    @NSManaged public var isNotificaionPushFlag: Bool
    @NSManaged public var isNotificaionPushTransfer: Bool
    @NSManaged public var isNotificaionPushReply: Bool
    @NSManaged public var isNotificaionPushSubscribe: Bool
    @NSManaged public var isNotificaionPushUnsubscribe: Bool
    @NSManaged public var isNotificaionPushMention: Bool
    @NSManaged public var isNotificaionPushRepost: Bool
    @NSManaged public var isNotificaionPushReward: Bool
    @NSManaged public var isNotificaionPushCuratorReward: Bool
    @NSManaged public var isNotificaionPushMessage: Bool
    @NSManaged public var isNotificaionPushWitnessVote: Bool
    @NSManaged public var isNotificaionPushWitnessCancelVote: Bool

}
