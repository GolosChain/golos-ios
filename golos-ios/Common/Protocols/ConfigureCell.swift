//
//  ConfigureCell.swift
//  Golos
//
//  Created by msm72 on 20.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath, blogEntry: BlogEntry?)
}
