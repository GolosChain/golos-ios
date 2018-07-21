//
//  PostFeedSupport.swift
//  Golos
//
//  Created by msm72 on 20.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol PostFeedCellSupport {
    var tagsValue: [String]? { get }
    var titleValue: String { get }
    var authorValue: String { get }
    var permlinkValue: String { get }
    var categoryValue: String { get }
    var allowVotesValue: Bool { get }
    var allowRepliesValue: Bool { get }
    var coverImageURLValue: String? { get }
}
