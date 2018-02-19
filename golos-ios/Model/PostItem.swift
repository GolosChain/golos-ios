//
//  PostItem.swift
//  Golos
//
//  Created by Grigory on 16/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

enum PostItemType {
    case text
    case image
}

struct PostItem {
    let content: String
    let type: PostItemType
}
