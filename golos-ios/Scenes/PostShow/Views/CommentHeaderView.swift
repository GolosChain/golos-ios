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
    case headerEmpty
}

class CommentHeaderView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var infiniteScrollingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var view: UIView! {
        didSet {
            self.view.tune()
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
//            self.contentView.backgroundColor = UIColor.red
            self.contentView.tune()
        }
    }
    
    @IBOutlet weak var emptyItemsLabel: UILabel! {
        didSet {
            self.emptyItemsLabel.tune(withText: "",
                                      hexColors: veryDarkGrayWhiteColorPickers,
                                      font: UIFont(name: "SFProDisplay-Regular", size: 13.0),
                                      alignment: .center,
                                      isMultiLines: true)
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if frame.height == 0 {
            frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 48.0))
        }
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }

    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: CommentHeaderView.self), bundle: Bundle(for: CommentHeaderView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }

    func set(mode: CommentHeaderViewMode) {
        switch mode {
        case .headerEmpty:
            self.emptyItemsLabel.isHidden       =   false
            self.infiniteScrollingActivityIndicator.stopAnimating()
            
        case .header:
            self.emptyItemsLabel.isHidden       =   true
            self.infiniteScrollingActivityIndicator.startAnimating()
            
        default:
            self.emptyItemsLabel.isHidden       =   true
            self.infiniteScrollingActivityIndicator.stopAnimating()
        }
    }
}
