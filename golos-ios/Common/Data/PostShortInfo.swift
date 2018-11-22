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
    let id: Int64?
    let title: String?
    let author: String?
    let nsfwPath: String?
    let permlink: String?
    let parentTag: String?
    let indexPath: IndexPath?
    let parentAuthor: String?
    let parentPermlink: String?
    let activeVotesCount: Int64
    
    // MARK: - Class Initialization
    init(id: Int64? = nil, title: String? = nil, author: String? = nil, permlink: String? = nil, parentTag: String? = nil, indexPath: IndexPath? = nil, parentAuthor: String? = nil, parentPermlink: String? = nil, activeVotes: Int64 = 0, nsfwPath: String? = nil) {
        self.id                 =   id
        self.title              =   title
        self.author             =   author
        self.nsfwPath           =   nsfwPath
        self.permlink           =   permlink
        self.parentTag          =   parentTag
        self.indexPath          =   indexPath
        self.parentAuthor       =   parentAuthor
        self.parentPermlink     =   parentPermlink
        self.activeVotesCount   =   activeVotes
    }
}
