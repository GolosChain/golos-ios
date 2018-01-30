//
//  ArticleFooterTableViewCell.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ArticleFooterTableViewCellDelegate: class {
    func didPressUpvote(at cell: ArticleFooterTableViewCell)
    func didPressComments(at cell: ArticleFooterTableViewCell)
    func didPressFavorite(at cell: ArticleFooterTableViewCell)
    func didPressPromote(at cell: ArticleFooterTableViewCell)
    func didPressDonate(at cell: ArticleFooterTableViewCell)
}

class ArticleFooterTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet private weak var tagsView: TagsView!
    @IBOutlet private weak var upvoteButton: UIButton!
    @IBOutlet private weak var upvoteAmountButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var promoteButton: UIButton!
    @IBOutlet private weak var donateButton: UIButton!
    
    @IBOutlet var tagsViewHeightConstraint: NSLayoutConstraint!
    
    
    //Delegate
    weak var delegate: ArticleFooterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    //MARK: SetupUI
    private func setupUI() {
        let greenColor = UIColor.Project.articleButtonsGreenColor
        let grayColor = UIColor.Project.articleButtonsGrayColor
        let blackColor = UIColor.Project.articleBlackColor
        
        promoteButton.tintColor = greenColor
        promoteButton.setTitleColor(blackColor, for: .normal)
        promoteButton.layer.masksToBounds = true
        promoteButton.layer.borderWidth = 1.0
        promoteButton.layer.borderColor = greenColor.cgColor
        promoteButton.layer.cornerRadius = 4.0
        
        donateButton.tintColor = greenColor
        donateButton.setTitleColor(blackColor, for: .normal)
        donateButton.layer.masksToBounds = true
        donateButton.layer.borderWidth = 1.0
        donateButton.layer.borderColor = greenColor.cgColor
        donateButton.layer.cornerRadius = 4.0
        
        upvoteButton.tintColor = grayColor
        upvoteButton.setTitleColor(blackColor, for: .normal)
        
        upvoteAmountButton.tintColor = grayColor
        upvoteAmountButton.setTitleColor(blackColor, for: .normal)
        
        commentsButton.tintColor = grayColor
        commentsButton.setTitleColor(blackColor, for: .normal)
        
        favoriteButton.tintColor = grayColor
        favoriteButton.setTitleColor(blackColor, for: .normal)
    }
    
    
    //MARK: Actions
    @IBAction func upvoteButtonPressed(_ sender: Any) {
        delegate?.didPressUpvote(at: self)
    }
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        delegate?.didPressComments(at: self)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        delegate?.didPressFavorite(at: self)
    }
    
    @IBAction func promoteButtonPressed(_ sender: Any) {
        delegate?.didPressPromote(at: self)
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        delegate?.didPressDonate(at: self)
    }
    
    //MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticleFooterTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
    
}


//MARK: Setters
extension ArticleFooterTableViewCell {
    var upvoteString: String? {
        get {return upvoteButton.title(for: .normal)}
        set {upvoteButton.setTitle(newValue, for: .normal) }
    }
    
    var upvoteAmountString: String? {
        get {return upvoteAmountButton.title(for: .normal)}
        set {upvoteAmountButton.setTitle(newValue, for: .normal) }
    }
    
    var commentsAmountString: String? {
        get {return commentsButton.title(for: .normal)}
        set {commentsButton.setTitle(newValue, for: .normal) }
    }
    
    var isUpvote: Bool {
        get {return false}
        set {upvoteButton.tintColor = newValue
            ? UIColor.Project.articleButtonsGreenColor
            : UIColor.Project.articleButtonsGrayColor}
    }
    
    var isComment: Bool {
        get {return false}
        set {commentsButton.tintColor = newValue
            ? UIColor.Project.articleButtonsGreenColor
            : UIColor.Project.articleButtonsGrayColor}
    }
    
    var isFavorite: Bool {
        get {return false}
        set {favoriteButton.tintColor = newValue
            ? UIColor.Project.articleButtonsGreenColor
            : UIColor.Project.articleButtonsGrayColor}
    }
    
    var tags: [String] {
        get {return tagsView.tagStringArray}
        set {
            tagsView.tagStringArray = newValue
            tagsViewHeightConstraint.isActive = newValue.count == 0
        }
    }
}
