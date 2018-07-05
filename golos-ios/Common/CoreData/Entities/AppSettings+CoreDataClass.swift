//
//  AppSettings+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 05.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AppSettings)
public class AppSettings: NSManagedObject {
    // MARK: - Class Functions
    class func instance() -> AppSettings {
        if let app = CoreDataManager.instance.readEntity(withName: "AppSettings", andPredicateParameters: nil) as? AppSettings {
            return app
        }
        
        return CoreDataManager.instance.createEntity("AppSettings") as! AppSettings
    }
    
    
    // MARK: - Custom Functions
    func setStartWithWelcomeScene(_ value: Bool) {
        self.startWithWelcomeScene = value
        self.save()
    }
}
