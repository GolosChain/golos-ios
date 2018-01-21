//
//  FeedMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol FeedMediatorDelegate: class {
    func didChangeFeedTab(_ feedTab: FeedTab)
}

class FeedMediator: NSObject {
    weak var presenter: FeedPresenter!
    weak var delegate: FeedMediatorDelegate?
}

extension FeedMediator: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let selectedTab = presenter.selectedFeedTab else {return nil}
        guard let indexOfSelectedTab = presenter.getFeedTabs().index(of: selectedTab) else {return nil}
        guard indexOfSelectedTab > 0 else {return nil}
        
        let previousIndex = indexOfSelectedTab - 1
        let previousFeedTap = presenter.getFeedTabs()[previousIndex]
        
        let vc = FeedTabViewController()
        vc.feedType = previousFeedTap.type
        
        
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let selectedTab = presenter.selectedFeedTab else {return nil}
        guard let indexOfSelectedTab = presenter.getFeedTabs().index(of: selectedTab) else {return nil}
        guard indexOfSelectedTab < presenter.getFeedTabs().count - 1 else {return nil}
        
        let nextIndex = indexOfSelectedTab + 1
        let nextFeedTab = presenter.getFeedTabs()[nextIndex]
        
        let vc = FeedTabViewController()
        vc.feedType = nextFeedTab.type
        
        return vc
    }
}

extension FeedMediator: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first as? FeedTabViewController else {
            return
        }
        
        let type = viewController.feedType
        let tabItem = presenter.getFeedTabs().first { tab -> Bool in
            tab.type == type
        }
        
        presenter.selectedFeedTab = tabItem
        delegate?.didChangeFeedTab(tabItem)
    }
}
