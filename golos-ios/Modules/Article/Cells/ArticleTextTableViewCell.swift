//
//  ArticleTextTableViewCell.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleTextTableViewCell: UITableViewCell {
    
    //Constants
    private static let bodyEdgesOffset: CGFloat = 12.0
    
    @IBOutlet weak private var articleTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    
    // MARK: SetupUI
    private func setupUI() {
        articleTextView.textContainerInset = UIEdgeInsets(top: 0,
                                                       left: ArticleTextTableViewCell.bodyEdgesOffset,
                                                       bottom: 0,
                                                       right: 0)
    }
    
    
    // MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticleTextTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}
