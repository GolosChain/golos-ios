//
//  ReusableCell.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

protocol ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath)
}


extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
