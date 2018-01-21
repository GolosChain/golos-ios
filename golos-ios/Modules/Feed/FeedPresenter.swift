//
//  FeedPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol FeedPresenterProtocol: class {
    func getFeedTabs() -> [FeedTab]
    func getActiveFeedTab() -> FeedTab
    func getTabAfter(_ tab: FeedTab) -> FeedTab?
    func getTabBefore(_ tab: FeedTab) -> FeedTab?
    func setActiveTab(_ tab: FeedTab)
    func getFeedTab(at index: Int) -> FeedTab?
}

protocol FeedViewProtocol: class {
    func didChangeActiveIndex(_ index: Int)
}

class FeedPresenter: NSObject {
    private var feedTabs: [FeedTab]!
    private var activeFeedTab = FeedTab(type: .popular)
    
    weak var feedView: FeedViewProtocol!
    
    override init() {
        super.init()
        
        self.feedTabs = [
            FeedTab(type: .popular),
            FeedTab(type: .hot),
            FeedTab(type: .new),
            FeedTab(type: .promoted)
        ]
        
        guard let first = self.feedTabs.first else {
            return
        }
        self.activeFeedTab = first
    }
}


//MARK: FeedPresenterProtocol
extension FeedPresenter: FeedPresenterProtocol {
    func getTabAfter(_ tab: FeedTab) -> FeedTab? {
        guard let index = feedTabs.index(of: tab) else {return nil}
        guard index < feedTabs.count - 1 else {return nil}
        
        let nextTab = feedTabs[index + 1]
        return nextTab
    }
    
    func getTabBefore(_ tab: FeedTab) -> FeedTab? {
        guard let index = feedTabs.index(of: tab) else {return nil}
        guard index > 0 else {return nil}
        
        let previousTab = feedTabs[index - 1]
        return previousTab
    }
    
    func getFeedTabs() -> [FeedTab] {
        return feedTabs
    }
    
    func getActiveFeedTab() -> FeedTab {
        return self.activeFeedTab
    }
    
    func setActiveTab(_ tab: FeedTab) {
        guard tab != activeFeedTab,
        let index = feedTabs.index(of: tab) else {return}
        
        self.activeFeedTab = tab
        feedView.didChangeActiveIndex(index)
    }
    
    func getFeedTab(at index: Int) -> FeedTab? {
        guard index >= 0 && index < feedTabs.count else {return nil}
        let tab = feedTabs[index]
        return tab
    }
}
