//
//  PostsFeedType.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Localize_Swift

enum PostsFeedType: String {
    case new
    case actual
    case popular
    case promoted
    
    func caseTitle() -> String {
        switch self {
        case .new:          return "New".localized()
        case .actual:       return "Actual".localized()
        case .popular:      return "Popular".localized()
        case .promoted:     return "Promoted".localized()
        }
    }
}
