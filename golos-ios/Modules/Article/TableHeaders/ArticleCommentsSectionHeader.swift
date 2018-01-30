// MARK: ads

//
//  ArticleCommentsSectionHeader.swift
//  Golos
//
//  Created by Grigory on 30/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ArticleCommentsSectionHeaderDelegate: class {
    func didPressHideShowCommentsButton(at header: ArticleCommentsSectionHeader)
}

class ArticleCommentsSectionHeader: UITableViewHeaderFooterView {

    // MARK: Outlets
    @IBOutlet weak var commentsAmountLabel: UILabel!
    @IBOutlet weak var commentsTitleLabel: UILabel!
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var newPostsButton: UIButton!
    @IBOutlet weak var hideShowCommentsButton: UIButton!
    
    
    
    // MARK: Delegate
    weak var delegate: ArticleCommentsSectionHeaderDelegate?
    
    
    var isExpanded = false {
        didSet {
            updateButton()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    // MARK: Setup
    private func setup() {
        hideShowCommentsButton.setBorderButtonRoundEdges()
        hideShowCommentsButton.layer.cornerRadius = 4.0
        hideShowCommentsButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        hideShowCommentsButton.titleLabel?.font = Fonts.shared.medium(with: 8.0)
        updateButton()
        
        commentsTitleLabel.textColor = UIColor.Project.articleBlackColor
        commentsTitleLabel.font = Fonts.shared.regular(with: 14.0)
        
        commentsAmountLabel.textColor = UIColor.Project.commentsAmountColor
        commentsAmountLabel.font = Fonts.shared.regular(with: 14.0)
        
        sortByLabel.textColor = UIColor.Project.commentsAmountColor
        sortByLabel.font = Fonts.shared.regular(with: 10.0)
        
        newPostsButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        newPostsButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
    }
    
    private func updateButton() {
        let title = isExpanded ? "Скрыть комментарии" : "Показать комментарии"
        hideShowCommentsButton.setTitle(title, for: .normal)
    }
    
    // MARK: Actions
    @IBAction func hideShowCommentsButtonPressed(_ sender: Any) {
        updateButton()
        delegate?.didPressHideShowCommentsButton(at: self)
    }
    
    // MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticleCommentsSectionHeader.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}
