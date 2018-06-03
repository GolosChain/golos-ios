//
//  ProfileFeedContainerItem.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileFeedContainerItemDelegate: class {
    func didScrollItem(_ item: ProfileFeedContainerItem)
}

protocol ProfileFeedContainerItem {
    var itemScrollView: UIScrollView { get }
    var delegate: ProfileFeedContainerItemDelegate? { get set }
    
    func setHeaderHeight(_ headerHeight: CGFloat, minimizedHeaderHeight: CGFloat)
    func changeItemScrollViewOffset(_ offset: CGPoint)
}
