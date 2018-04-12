//
//  RequestAPI.swift
//  Golos
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct RequestAPI: Codable {
    let id: Int
    let method: String
    let jsonrpc: String
    let params: [String]
}

struct RequestParams: Codable {
    var limit: Int
}
