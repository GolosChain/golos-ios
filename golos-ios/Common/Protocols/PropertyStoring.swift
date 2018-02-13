//
//  PropertyStoring.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol PropertyStoring {
    associatedtype StorePropertyType
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: StorePropertyType) -> StorePropertyType
}

extension PropertyStoring {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: StorePropertyType) -> StorePropertyType {
        guard let value = objc_getAssociatedObject(self, key) as? StorePropertyType else {
            return defaultValue
        }
        return value
    }
}
