//
//  UITableView+Extensions.swift
//  Golos
//
//  Created by msm72 on 10.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

final class UITableViewWithReloadCompletion: UITableView {
    // MARK: - Properties
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
}
