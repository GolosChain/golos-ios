//
//  PostShortInfo.swift
//  Golos
//
//  Created by msm72 on 12.09.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

struct PostShortInfo {
    // MARK: - Properties
    let title: String?
    let author: String?
    let permlink: String?
    let indexPath: IndexPath?
    let parentAuthor: String?
    let parentPermlink: String?
    
    
    // MARK: - Class Initialization
    init(title: String? = nil, author: String? = nil, permlink: String? = nil, indexPath: IndexPath? = nil, parentAuthor: String? = nil, parentPermlink: String? = nil) {
        self.title              =   title
        self.author             =   author
        self.permlink           =   permlink
        self.indexPath          =   indexPath
        self.parentAuthor       =   parentAuthor
        self.parentPermlink     =   parentPermlink
    }
}
