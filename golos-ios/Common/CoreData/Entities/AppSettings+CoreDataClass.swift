//
//  AppSettings+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 05.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
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
    
    class var startWithWelcomeScene: Bool {
        get {
            return (CoreDataManager.instance.readEntities(withName:                     "AppSettings",
                                                          withPredicateParameters:      settingsPredicate,
                                                          andSortDescriptor:            nil)?.first as! AppSettings).startWithWelcomeScene
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

    func setup() {
        self.language               =   Locale.current.languageCode ?? "en"
        self.userNickName           =   User.current?.nickName ?? "Anonymous"
        self.isAppThemeDark         =   false
        self.startWithWelcomeScene  =   true

        ThemeManager.setTheme(index: 0)
        Localize.setCurrentLanguage(self.language)

        self.save()
    }
}
