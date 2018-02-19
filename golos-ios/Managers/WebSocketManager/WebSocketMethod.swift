//
//  WebSocketMethod.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

enum WebSocketMethod: String {
    case getDiscussionsNew = "get_discussions_by_created"
    case getDiscussionsPopular = "get_discussions_by_trending"
    case getDiscussionsActual = "get_discussions_by_hot"
    case getDiscussionsPromo = "get_discussions_by_feed"
    
    case getPostComments = "get_content_replies"
    
    case getAccounts = "get_accounts"
}
