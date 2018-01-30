//
//  ArticleMediator.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleMediator: NSObject {
    private let articleTitleCellIdentifier = ArticleTitleTableViewCell.reuseIdentifier!
    private let articleImageCellIdentifier = ArticleImageTableViewCell.reuseIdentifier!
    private let articleTextCellIdentifier = ArticleTextTableViewCell.reuseIdentifier!
    private let articleFooterCellIdentifier = ArticleFooterTableViewCell.reuseIdentifier!
    private let articlePostedInCellIdentifier = ArticlePostedInTableViewCell.reuseIdentifier!
    
    private let articleCommentsSectionHeaderIdentifier = ArticleCommentsSectionHeader.reuseIdentifier!
    private let articleCommentCellIdentifier = ArticleCommentTableViewCell.reuseIdentifier!
    
    
    weak var tableView: UITableView!
    
    private var isCommentsExpanded = false
    
    
    //MARK: Configure
    func configure(tableView: UITableView) {
        self.tableView = tableView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionFooterHeight = 0
        
        registerCells()
    }
    
    func registerCells() {
        let nib = UINib(nibName: articleTitleCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: articleTitleCellIdentifier)
        let nib1 = UINib(nibName: articleImageCellIdentifier, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: articleImageCellIdentifier)
        let nib2 = UINib(nibName: articleTextCellIdentifier, bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: articleTextCellIdentifier)
        let nib4 = UINib(nibName: articleFooterCellIdentifier, bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: articleFooterCellIdentifier)
        let nib5 = UINib(nibName: articlePostedInCellIdentifier, bundle: nil)
        tableView.register(nib5, forCellReuseIdentifier: articlePostedInCellIdentifier)
        
        let nib6 = UINib(nibName: articleCommentsSectionHeaderIdentifier, bundle: nil)
        tableView.register(nib6, forHeaderFooterViewReuseIdentifier: articleCommentsSectionHeaderIdentifier)
        let nib7 = UINib(nibName: articleCommentCellIdentifier, bundle: nil)
        tableView.register(nib7, forCellReuseIdentifier: articleCommentCellIdentifier)
    }
}


//MARK: UITableViewCellDataSource
extension ArticleMediator: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell!
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: articleTitleCellIdentifier) as! ArticleTitleTableViewCell
                resultCell = cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: articleImageCellIdentifier) as! ArticleImageTableViewCell
                resultCell = cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: articleTextCellIdentifier) as! ArticleTextTableViewCell
                resultCell = cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: articleImageCellIdentifier) as! ArticleImageTableViewCell
                resultCell = cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: articleTextCellIdentifier) as! ArticleTextTableViewCell
                resultCell = cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: articleFooterCellIdentifier) as! ArticleFooterTableViewCell
                cell.tags = ["Путешествия", "Творчество", "Блокчейн", "Жизнь", "Мираж"]
                cell.delegate = self
                resultCell = cell
            default:
                resultCell = UITableViewCell()
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: articlePostedInCellIdentifier) as! ArticlePostedInTableViewCell
                cell.isAuthor = false
                cell.delegate = self
                resultCell = cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: articlePostedInCellIdentifier) as! ArticlePostedInTableViewCell
                cell.isAuthor = true
                cell.delegate = self
                cell.topLabel.text = "Mike Davidson"
                resultCell = cell
            default:
                resultCell = UITableViewCell()
            }
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: articleCommentCellIdentifier) as! ArticleCommentTableViewCell
            cell.delegate = self
            resultCell = cell
        } else {
            return UITableViewCell()
        }
        
        return resultCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }
        if section == 1 {
            return 2
        }
        
        return isCommentsExpanded ? 10 : 0
    }
}


//MARK: UITableViewDelegate
extension ArticleMediator: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        if section == 1 {return nil}
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: articleCommentsSectionHeaderIdentifier) as! ArticleCommentsSectionHeader
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {return 1}
        if section == 1 {return 5}
        return 59
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {return 1}
        if section == 1 {return 5}
        return 59
    }
}


//MARK: ArticleCommentsSectionHeaderDelegate
extension ArticleMediator: ArticleCommentsSectionHeaderDelegate {
    func didPressHideShowCommentsButton(at header: ArticleCommentsSectionHeader) {
        isCommentsExpanded = !isCommentsExpanded

        UIView.setAnimationsEnabled(false)
        tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath.init(row: NSNotFound, section: 2), at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
}


//MARK: ArticleFooterTableViewCellDelegate
extension ArticleMediator: ArticleFooterTableViewCellDelegate {
    func didPressUpvote(at cell: ArticleFooterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
    
    func didPressComments(at cell: ArticleFooterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
    
    func didPressFavorite(at cell: ArticleFooterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
    
    func didPressPromote(at cell: ArticleFooterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
    
    func didPressDonate(at cell: ArticleFooterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
}


// MARK: ArticlePostedInTableViewCellDelegate
extension ArticleMediator: ArticlePostedInTableViewCellDelegate {
    func didPressSubsribeButton(at cell: ArticlePostedInTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
}


// MARK: ArticleCommentTableViewCellDelegate
extension ArticleMediator: ArticleCommentTableViewCellDelegate {
    func didPressUpvote(at cell: ArticleCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
    
    func didPressComments(at cell: ArticleCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
    
    func didPressReply(at cell: ArticleCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        Utils.inDevelopmentAlert()
    }
}
