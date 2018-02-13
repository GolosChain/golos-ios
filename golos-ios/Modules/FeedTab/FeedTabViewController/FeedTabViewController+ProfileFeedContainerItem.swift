//
//  FeedTabViewController+ProfileFeedContainerItem.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension FeedTabViewController: ProfileFeedContainerItem, PropertyStoring {
    
    
    typealias StorePropertyType = ProfileFeedContainerItemDelegate?
    
    private struct CustomProperties {
        static var delegate: ProfileFeedContainerItemDelegate? = nil
    }
    
    var itemScrollView: UIScrollView {
        return tableView
    }
    
    var delegate: ProfileFeedContainerItemDelegate? {
        get {
            return getAssociatedObject(&CustomProperties.delegate,
                                       defaultValue: CustomProperties.delegate)
        }
        set {
            objc_setAssociatedObject(self,
                                     &CustomProperties.delegate,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
   
    func setHeaderHeight(_ headerHeight: CGFloat, minimizedHeaderHeight: CGFloat) {
        let tableHeader = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: UIScreen.main.bounds.width,
                                               height: minimizedHeaderHeight))
        tableView.tableHeaderView = tableHeader
        
        itemScrollView.contentInset = UIEdgeInsets(
            top: headerHeight - minimizedHeaderHeight,
            left: 0,
            bottom: 0,
            right: 0
        )
        itemScrollView.scrollIndicatorInsets = UIEdgeInsets(
            top: headerHeight - minimizedHeaderHeight,
            left: 0,
            bottom: 0,
            right: 0)
    }
    
    func changeItemScrollViewOffset(_ offset: CGPoint) {
        itemScrollView.contentOffset = offset
    }
}
