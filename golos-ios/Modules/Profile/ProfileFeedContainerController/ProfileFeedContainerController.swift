//
//  ProfileFeedContainerController.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileFeedContainerControllerDelegate: class {
    func didChangeYOffset(_ yOffset: CGFloat)
}

class ProfileFeedContainerController: UIViewController {
    private var mainScrollView = UIScrollView()
    private var items = [UIViewController & ProfileFeedContainerItem]()
    
    private var headerHeight: CGFloat = 0
    private var minimizedHeaderHeight: CGFloat = 0
    
    
    weak var delegate: ProfileFeedContainerControllerDelegate?
    
    func setFeedItems(_ newItems: [UIViewController & ProfileFeedContainerItem],
                      headerHeight: CGFloat,
                      minimizedHeaderHeight: CGFloat) {
        self.headerHeight = headerHeight
        self.minimizedHeaderHeight = minimizedHeaderHeight
        
        for item in self.items {
            item.view.removeFromSuperview()
            item.removeFromParentViewController()
        }
        
        self.items = newItems
        for (index, item) in self.items.enumerated() {
            addChildViewController(item)
            mainScrollView.addSubview(item.view)
            item.didMove(toParentViewController: self)
            
            self.items[index].setHeaderHeight(
                headerHeight,
                minimizedHeaderHeight: minimizedHeaderHeight
            )
            self.items[index].delegate = self
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var width: CGFloat = 0
        let height: CGFloat = view.bounds.height
        for (index, item) in items.enumerated() {
            width += view.bounds.width
            let frame = CGRect(x: 0 + view.bounds.width * CGFloat(index),
                               y: 0,
                               width: view.bounds.width,
                               height: view.bounds.height)
            item.view.frame = frame
        }
        
        mainScrollView.contentSize = CGSize(width: width, height: height)
        
        let offset = CGPoint(x: 0, y: -headerHeight + minimizedHeaderHeight)
        for item in self.items {
            item.changeItemScrollViewOffset(offset)
        }
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        mainScrollView.isPagingEnabled = true
    }

}

extension ProfileFeedContainerController: ProfileFeedContainerItemDelegate {
    func didScrollItem(_ item: ProfileFeedContainerItem) {
        let scrollView = item.itemScrollView
        let offset = scrollView.contentOffset.y
        let resultOffset = offset + (self.headerHeight - self.minimizedHeaderHeight)
        
        delegate?.didChangeYOffset(resultOffset)
        
        if offset < 0 {
            for containerItem in self.items {
                let scrollIndicatorInsets = UIEdgeInsets(
                    top: -offset,
                    left: 0,
                    bottom: 0,
                    right: 0
                )
                containerItem.itemScrollView.contentOffset = scrollView.contentOffset
                containerItem.itemScrollView.scrollIndicatorInsets = scrollIndicatorInsets
            }
        }
    }
}
