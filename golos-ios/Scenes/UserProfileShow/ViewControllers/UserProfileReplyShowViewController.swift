//
//  UserProfileShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 29.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

class UserProfileReplyShowViewController: GSTableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var replyTableView: GSTableViewWithReloadCompletion! {
        didSet {
            self.cellIdentifier     =   "ReplyTableViewCell"
            self.postsTableView     =   self.replyTableView
        }
    }

    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload only visible cells
        guard self.replyTableView.visibleCells.count > 0 else {
            return
        }
        
        self.replyTableView.beginUpdates()
        self.replyTableView.reloadRows(at: self.replyTableView.indexPathsForVisibleRows!, with: .automatic)
        self.replyTableView.endUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
