//
//  LentaPostsShowViewController.swift
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

class LentaPostsShowViewController: GSTableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var lentaTableView: GSTableViewWithReloadCompletion! {
        didSet {
            self.postsTableView = self.lentaTableView
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

        self.title = "Lenta"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isNetworkAvailable {
            self.lentaTableView.tableHeaderView = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.lentaTableView.tableHeaderView?.isHidden = true
            self.lentaTableView.tableFooterView?.isHidden = true
            
            self.activityIndicatorView.stopAnimating()
            self.infiniteScrollingActivityIndicatorView.stopAnimating()
        })
    }
}
