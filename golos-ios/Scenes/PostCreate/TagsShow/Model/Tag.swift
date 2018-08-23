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
    var title: String?
    var placeholder: String?
    var id: Int                 =   0
    var isFirst: Bool           =   false
    var cellWidth: CGFloat      =   78.0 * widthRatio
    
    
    // MARK: - Class Initialization
    init(placeholder: String?, id: Int, isFirst: Bool) {
        super.init()
        
//        self.placeholder        =   placeholder
        self.id                 =   id
        self.isFirst            =   isFirst
    }
}
