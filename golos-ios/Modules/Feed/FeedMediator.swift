//
//  FeedMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class FeedMediator: NSObject {
    weak var presenter: FeedPresenterProtocol!
    weak var pageViewController: UIPageViewController!

    func configure(pageViewController: UIPageViewController) {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        self.pageViewController = pageViewController
    }
    
    func setViewController(at index: Int, previousIndex: Int = 0) {
        guard let tab = presenter.getFeedTab(at: index) else {return}
        
        let animated = index != previousIndex
        let direction: UIPageViewControllerNavigationDirection = index < previousIndex ? .reverse : .forward
        let nextFeedTabViewController = FeedTabViewController()
        nextFeedTabViewController.feedTab = tab
        
        pageViewController.setViewControllers([nextFeedTabViewController],
                                              direction: direction,
                                              animated: animated,
                                              completion: nil)
    }
}

extension FeedMediator: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let feedTabViewController = viewController as? FeedTabViewController else {return nil}
        guard let previousTab = presenter.getTabBefore(feedTabViewController.feedTab) else {return nil}
        
        let previousFeedTabViewController = FeedTabViewController()
        previousFeedTabViewController.feedTab = previousTab
        
        return previousFeedTabViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let feedTabViewController = viewController as? FeedTabViewController else {return nil}
        guard let nextTab = presenter.getTabAfter(feedTabViewController.feedTab) else {return nil}
        
        let nextFeedTabViewController = FeedTabViewController()
        nextFeedTabViewController.feedTab = nextTab
        
        return nextFeedTabViewController
    }
}

extension FeedMediator: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let feedTabViewController = pageViewController.viewControllers?.first as? FeedTabViewController else {return}
        
        presenter.setActiveTab(feedTabViewController.feedTab)
    }
}
