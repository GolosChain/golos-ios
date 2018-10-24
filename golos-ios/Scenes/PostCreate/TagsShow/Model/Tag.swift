//
//  Tag.swift
//  golos-ios
//
//  Created by msm72 on 18.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class Tag: NSObject {
    // MARK: - Properties
    var id: Int             =   0
    var title: String?
    var isAddTag: Bool      =   false
    var cellWidth: CGFloat  =   78.0 * widthRatio
    
    
    // MARK: - Class Initialization
    init(id: Int, isAddTag: Bool = false) {
        super.init()
        
        self.id             =   id
        self.isAddTag       =   isAddTag
        
        if isAddTag {
            self.cellWidth  =   36.0 * widthRatio
        }
    }
}
