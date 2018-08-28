//
//  ImageCached+CoreDataProperties.swift
//  Golos
//
//  Created by msm72 on 23.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageCached: CachedImageFrom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCached> {
        return NSFetchRequest<ImageCached>(entityName: "ImageCached")
    }

    @NSManaged public var created: NSDate
    @NSManaged public var cachedKey: String
    
    // MARK: - CachedImageFrom protocol implementation
    @NSManaged public var fromItem: String

}
