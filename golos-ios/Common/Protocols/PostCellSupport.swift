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
    var activeVotesCount: Int16 { get set }
    var url: String? { get set }
    var activeVotes: NSSet? { get set }
    var authorReputation: String { get set }
    var pendingPayoutValue: Float { get set }

    var tags: [String]? { get set }
    var rebloggedBy: [String]? { get set }

    var active: Date { get set }
    var created: Date { get set }
    var lastUpdate: Date { get set }
    var lastPayout: Date { get set }
}
