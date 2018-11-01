//
//  UserCellSupport.swift
//  Golos
//
//  Created by msm72 on 10/31/18.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol UserCellSupport {
    var modeValue: Int16? { get set }
    var nameValue: String { get set }
    var nickNameValue: String { get set }
    var reputationValue: String { get set }
}
