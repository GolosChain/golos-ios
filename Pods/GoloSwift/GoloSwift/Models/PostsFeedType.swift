//
//  PostsFeedType.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

/// Feed type
public enum PostsFeedType: String {
    case new
    case blog
    case lenta
    case reply
    case promo
    case actual
    case answers
    case popular
    case comment
    
    public func caseTitle() -> String {
        switch self {
        case .new:          return "New"
        case .blog:         return "Blog"
        case .lenta:        return "Lenta"
        case .reply:        return "Reply"
        case .promo:        return "Promo"
        case .actual:       return "Actual"
        case .answers:      return "Answers"
        case .popular:      return "Popular"
        case .comment:      return "Comment"
        }
    }
    
    func caseAPIParameters() -> String {
        switch self {
        case .new:          return "get_discussions_by_created"
        case .blog:         return "get_discussions_by_blog"
        case .lenta:        return "get_discussions_by_feed"
        case .reply:        return "get_replies_by_last_update"
        case .promo:        return "get_discussions_by_promoted"
        case .actual:       return "get_discussions_by_hot"
        case .answers:      return ""
        case .popular:      return "get_discussions_by_trending"
        case .comment:      return "get_all_content_replies"
        }
    }
}
