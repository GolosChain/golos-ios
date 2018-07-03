//
//  NSManagedObject+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 23.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import CoreData
import Foundation

extension NSManagedObject {
    func save() {
        CoreDataManager.instance.contextSave()
    }
}
