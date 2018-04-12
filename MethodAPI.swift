//
//  MethodAPI.swift
//  Golos
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

/// API methods.
public enum MethodApiType {
    /// Displays a limited number of publications beginning with the most expensive of the award.
    case getDiscussionsByTrending(limit: Int)
}
