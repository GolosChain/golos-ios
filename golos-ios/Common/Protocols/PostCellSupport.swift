//
//  PostFeedSupport.swift
//  Golos
//
//  Created by msm72 on 20.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol PostCellSupport: PaginationSupport, MetaDataSupport {
    var id: Int64 { get set }
    var parentAuthor: String? { get set }
    var category: String { get set }
    var title: String { get set }
    var body: String { get set }
    var parentPermlink: String? { get set }
    var allowVotes: Bool { get set }
    var allowReplies: Bool { get set }
    var jsonMetadata: String? { get set }
    var url: String? { get set }
    var authorReputation: String { get set }
    var pendingPayoutValue: Float { get set }
    var children: Int64 { get set }
    
    var likeCount: Int64 { get set }
    var currentUserLiked: Bool { get set }
    
    var commentsCount: Int64 { get set }
    var currentUserCommented: Bool { get set }

    var dislikeCount: Int64 { get set }
    var currentUserDisliked: Bool { get set }

    var tags: [String]? { get set }

    var authorReblog: String? { get set }
    var rebloggedBy: [String]? { get set }
    
    var active: Date { get set }
    var created: Date { get set }
    var lastUpdate: Date { get set }
    var lastPayout: Date { get set }
}
