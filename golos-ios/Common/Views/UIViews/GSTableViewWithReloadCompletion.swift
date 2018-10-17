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

final class GSTableViewWithReloadCompletion: UITableView {
    // MARK: - Properties
    var tableViewManager: GSTableViewController = GSTableViewController()
    
    private var reloadDataCompletionBlock: (() -> Void)?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect, style: UITableView.Style) {
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
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        DispatchQueue.main.async(execute: {
            self.reloadDataCompletionBlock = completion
            
            // Reload only after start App
//            guard self.visibleCells.count > 0 else {
                super.reloadData()
//                return
//            }            
        })
    }
    
    
    // MARK: - Custom Functions
    private func setup() {
        delaysContentTouches    =   false
        
        self.delegate           =   self.tableViewManager
        self.dataSource         =   self.tableViewManager
        
        // Set automatic dimensions for row height
        self.rowHeight          =   UITableView.automaticDimension
        self.estimatedRowHeight =   320.0 * heightRatio
    }
}
