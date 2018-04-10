//
//  WebSocketMethod.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

enum WebSocketMethod: String {
    // Database API. Part 1 (https://wiki.golos.io/golosd/api/api-golos-ch1.html)
    case getPost                =   "get_content"
    case getAccounts            =   "get_accounts"
    case getPostReplies         =   "get_content_replies"
    
    // Database API. Part 2 (https://wiki.golos.io/golosd/api/api-golos-ch2.html)
    case getDiscussionsNew      =   "get_discussions_by_created"
    case getDiscussionsPromo    =   "get_discussions_by_feed"
    case getDiscussionsActual   =   "get_discussions_by_hot"
    case getDiscussionsPopular  =   "get_discussions_by_trending"
    
    // Market_History & Follow API's. Part 3 (https://wiki.golos.io/golosd/api/api-golos-ch3.html)
    
    // Network Brodcast & Login API's. Part 4 (https://wiki.golos.io/golosd/api/api-golos-ch4.html)
}
