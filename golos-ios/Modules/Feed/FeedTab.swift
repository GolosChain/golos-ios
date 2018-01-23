//
//  FeedTab.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct FeedTab {
    let type: FeedType
}

extension FeedTab: Equatable {
    static func == (lhs: FeedTab, rhs: FeedTab) -> Bool {
        return lhs.type == rhs.type
    }
}
