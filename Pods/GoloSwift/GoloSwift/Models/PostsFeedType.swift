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
    case lenta
    case reply
    case actual
    case answers
    case popular
    case promoted

    public func caseTitle() -> String {
        switch self {
        case .new:          return "New"
        case .lenta:        return "Lenta"
        case .reply:        return "Reply"
        case .actual:       return "Actual"
        case .answers:      return "Answers"
        case .popular:      return "Popular"
        case .promoted:     return "Promoted"
        }
    }
    
    func caseAPIParameters() -> String {
        switch self {
        case .new:          return "get_discussions_by_created"
        case .lenta:        return "get_discussions_by_blog"
        case .reply:        return "get_replies_by_last_update"
        case .actual:       return "get_discussions_by_hot"
        case .answers:      return ""
        case .popular:      return "get_discussions_by_trending"
        case .promoted:     return "get_discussions_by_promoted"
        }
    }
}
