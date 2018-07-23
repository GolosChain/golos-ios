//
//  MetaDataSupport.swift
//  Golos
//
//  Created by msm72 on 20.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol MetaDataSupport {
    func set(tags: [String]?)
    func set(coverImageURL: String?)
    
    var coverImageURL: String? { get set }
}
