//
//  NSLayoutConstraint+Extensions.swift
//  Golos
//
//  Created by msm72 on 9/29/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

extension NSLayoutConstraint {
    override open var description: String {
        let id = identifier ?? ""
        
        return "id: \(id), constant: \(constant)"
    }
}
