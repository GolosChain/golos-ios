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
    func didMainScroll(to pageIndex: Int)
}

class ProfileFeedContainerController: UIViewController {
    // MARK: - Properties
    private var mainScrollView = GSScrollView()
    private var items = [UIViewController & ProfileFeedContainerItem]()
    
    private var headerHeight: CGFloat = 0
    private var minimizedHeaderHeight: CGFloat = 0
    
    
    // MARK: - Main Scrolling
    private var startIndex: Int = 0
    private var lastContentOffsetX: CGFloat = 0
    private var needToDelegateUse = true
    
    weak var delegate: ProfileFeedContainerControllerDelegate?
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var width: CGFloat = 0
        let height: CGFloat = view.bounds.height
        
        for (index, item) in items.enumerated() {
            width += view.bounds.width
        
            let frame = CGRect(x:       0 + view.bounds.width * CGFloat(index),
                               y:       0,
                               width:   view.bounds.width,
                               height:  view.bounds.height)
           
            item.view.frame = frame
        }
        
        mainScrollView.contentSize = CGSize(width: width, height: height)
        
        let offset = CGPoint(x: 0, y: -headerHeight + minimizedHeaderHeight)
        
        for item in self.items {
            item.changeItemScrollViewOffset(offset)
        }
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainScrollView)
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints                        =   false
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive           =   true
        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive         =   true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     =   true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive       =   true
        
        mainScrollView.isPagingEnabled                  =   true
        mainScrollView.delegate                         =   self
        mainScrollView.showsHorizontalScrollIndicator   =   false
    }
    
    
    // MARK: - Change active item
    func setActiveItem(at index: Int) {
        let width = mainScrollView.bounds.width
        let xOffset = width * CGFloat(index)
        let contentOffset = CGPoint(x: xOffset, y: 0)
        
        self.needToDelegateUse = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.mainScrollView.contentOffset = contentOffset
        }) { (_) in
            self.needToDelegateUse = true
        }
    }
    
    
    // MARK: - Custom Functions
    func setFeedItems(_ newItems: [UIViewController & ProfileFeedContainerItem], headerHeight: CGFloat, minimizedHeaderHeight: CGFloat) {
        self.headerHeight           =   headerHeight
        self.minimizedHeaderHeight  =   minimizedHeaderHeight
        
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
}


// MARK: - ProfileFeedContainerItemDelegate
extension ProfileFeedContainerController: ProfileFeedContainerItemDelegate {
    func didScrollItem(_ item: ProfileFeedContainerItem) {
        let scrollView = item.itemScrollView
        let offset = scrollView.contentOffset.y
        let resultOffset = offset + (self.headerHeight - self.minimizedHeaderHeight)
        
        delegate?.didChangeYOffset(resultOffset)
        
        if offset < 0 {
            for containerItem in self.items {
                containerItem.changeItemScrollViewOffset(scrollView.contentOffset)
            }
        }
    }
}


// MARK: - UIScrollViewDelegate
extension ProfileFeedContainerController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.needToDelegateUse else {return}
        
        let width = scrollView.bounds.width
        let fractPage = Float(scrollView.contentOffset.x / width)
        let page = lroundf(fractPage)
        
        delegate?.didMainScroll(to: page)
    }
}
