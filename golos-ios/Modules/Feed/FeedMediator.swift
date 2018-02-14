//
//  FeedMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol FeedMediatorDelegate: class {
    func didChangePage(at index: Int)
}

class FeedMediator: NSObject {
    weak var presenter: FeedPresenterProtocol!
    weak var pageViewController: UIPageViewController!
    
    weak var delegate: FeedMediatorDelegate?

    func configure(pageViewController: UIPageViewController) {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        self.pageViewController = pageViewController
    }
    
    func setViewController(at index: Int, previousIndex: Int = 0) {
        guard let type = presenter.getPostsFeedType(at: index) else { return }
        
        let animated = index != previousIndex
        let direction: UIPageViewControllerNavigationDirection = index < previousIndex
            ? .reverse
            : .forward
        let viewController = PostsFeedViewController.nibInstance(with: type)
        
        pageViewController.setViewControllers([viewController],
                                              direction: direction,
                                              animated: animated,
                                              completion: nil)
    }
}

extension FeedMediator: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentViewController = viewController as? PostsFeedViewController else { return nil }
        guard let previousType = presenter.previousPostsFeedType(currentViewController.postsFeedType) else { return nil }
        
        let previousViewController = PostsFeedViewController.nibInstance(with: previousType)
        return previousViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentViewController = viewController as? PostsFeedViewController else { return nil }
        guard let nextType = presenter.nextPostsFeedType(currentViewController.postsFeedType) else { return nil }
        
        let nextViewController = PostsFeedViewController.nibInstance(with: nextType)
        return nextViewController
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
        guard let viewController = pageViewController.viewControllers?.first as? PostsFeedViewController else { return }
        let type = viewController.postsFeedType
        guard let index = presenter.getPostsFeedTypeArray().index(of: type) else { return }
        delegate?.didChangePage(at: index)
    }
}
