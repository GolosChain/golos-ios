//
//  UITableView+Extensions.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

@IBDesignable final class GSTableViewWithReloadCompletion: UITableView {
    // MARK: - Properties
    @IBInspectable var cellIdentifier: String! {
        didSet {
            // Add cells from XIB
            self.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        }
    }

    var tableViewManager: GSTableViewController = GSTableViewController()
    
    private var reloadDataCompletionBlock: (() -> Void)?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }

    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
    
    
    // MARK: - Custom Functions
    private func setup() {
        delaysContentTouches    =   false
        
        self.delegate           =   self.tableViewManager
        self.dataSource         =   self.tableViewManager
        
        // Set automatic dimensions for row height
        self.rowHeight          =   UITableViewAutomaticDimension
        self.estimatedRowHeight =   320.0 * heightRatio
        
    }
}
