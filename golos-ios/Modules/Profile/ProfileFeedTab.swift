//
//  ProfileFeedTab.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct ProfileFeedTab {
    let type: ProfileFeedType
}

extension ProfileFeedTab: Equatable {
    static func == (lhs: ProfileFeedTab, rhs: ProfileFeedTab) -> Bool {
        return lhs.type == rhs.type
    }
}
