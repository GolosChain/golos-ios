//
//  CommentHeaderView.swift
//  Golos
//
//  Created by msm72 on 10/21/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

enum CommentHeaderViewMode {
    case header
    case footer
}

class CommentHeaderView: UIView {
    // MARK: - Properties
    var viewMode: CommentHeaderViewMode = .header {
        didSet {
            self.viewMode == .header ? self.infiniteScrollingActivityIndicator.stopAnimating() : self.infiniteScrollingActivityIndicator.startAnimating()
            self.createCommentButton.isHidden = self.viewMode == .footer
        }
    }
    
    // Handlers
    var handlerCreateCommentButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var infiniteScrollingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var view: UIView! {
        didSet {
            self.view.tune()
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.tune()
        }
    }
    
    @IBOutlet weak var createCommentButton: UIButton! {
        didSet {
            self.createCommentButton.tune(withTitle:    "No Comments Title".localized(),
                                          hexColors:    [veryDarkGrayWhiteColorPickers, darkGrayWhiteColorPickers, darkGrayWhiteColorPickers, darkGrayWhiteColorPickers],
                                          font:         UIFont(name: "SFProDisplay-Regular", size: 13.0),
                                          alignment:    .left)
            
            self.createCommentButton.isHidden = false
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }

    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: CommentHeaderView.self), bundle: Bundle(for: CommentHeaderView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width * widthRatio, height: 48.0 * heightRatio))
    }

    func translateTitle() {
        self.createCommentButton.setTitle("No Comments Title".localized(), for: .normal)
    }
    
    func set(mode: CommentHeaderViewMode) {
        self.viewMode = mode
    }

    
    // MARK: - Actions
    @IBAction func createCommentButtonTapped(_ sender: UIButton) {
        self.handlerCreateCommentButtonTapped!()
    }
}
