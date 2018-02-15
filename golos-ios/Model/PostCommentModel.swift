//
//  PostCommentModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct PostCommentModel: Codable {
    let commentId: String
    let author: String
    let body: String
}
