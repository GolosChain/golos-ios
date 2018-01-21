//
//  FeedPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

class FeedPresenter: NSObject {
    private var feedTabs: [FeedTab]!
    
    var selectedFeedTab: FeedTab?
    
    override init() {
        super.init()
        
        self.feedTabs = [
            FeedTab(type: .trending),
            FeedTab(type: .hot),
            FeedTab(type: .created),
            FeedTab(type: .promoted)
        ]
        
        self.selectedFeedTab = self.feedTabs.first
    }
    
    
    func getFeedTabs() -> [FeedTab] {
        return feedTabs
    }
    
    func selectFeedTab(_ feedTab: FeedTab) {
        selectedFeedTab = feedTab
    }
}
