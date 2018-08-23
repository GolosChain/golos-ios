//
//  GSSegmentedControlViewController.swift
//  Golos
//
//  Created by msm72 on 16.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import Localize_Swift
import SJSegmentedScrollView

class GSPostsSegmentedControlViewController: SJSegmentedViewController {
    // MARK: - Properties
    var selectedSegment: SJSegmentTab?

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        self.setupSegmentedControl()
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    private func setupSegmentedControl() {
        let viewController1     =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        viewController1.title   =   "Lenta".localized()

        let viewController2     =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        viewController2.title   =   "Popular".localized()

        let viewController3     =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! ActualPostsShowViewController
        viewController3.title   =   "Actual".localized()

        let viewController4     =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        viewController4.title   =   "New".localized()

        let viewController5     =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        viewController5.title   =   "Promo".localized()

        headerViewController    =   User.current == nil ?   viewController2 : viewController1
        
        segmentControllers      =   User.current == nil ?   [ viewController2, viewController3, viewController4, viewController5 ] :
                                                            [ viewController1, viewController2, viewController3, viewController4, viewController5 ]

        headerViewHeight                =   0.0
        selectedSegmentViewHeight       =   2.0 * heightRatio
        headerViewOffsetHeight          =   0.0
        segmentTitleColor               =   UIColor(hexString: "#D6D6D6")
        selectedSegmentViewColor        =   UIColor(hexString: "#FFFFFF")
//        segmentShadow                   =   SJShadow.light()
        showsHorizontalScrollIndicator  =   false
        showsVerticalScrollIndicator    =   false
        segmentBounces                  =   true
        segmentTitleFont                =   UIFont(name: "SFProDisplay-Medium", size: 13.0 * widthRatio)!
        segmentBackgroundColor          =   UIColor(hexString: "#4469AF")
        
        delegate = self
    }
}


// MARK: - SJSegmentedViewControllerDelegate
extension GSPostsSegmentedControlViewController: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if selectedSegment != nil {
            selectedSegment?.titleColor(UIColor(hexString: "#D6D6D6"))
        }
        
        if segments.count > 0 {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(UIColor(hexString: "#FFFFFF"))
        }
    }
}
