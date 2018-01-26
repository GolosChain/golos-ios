//
//  FeedTabMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol FeedTabMediatorDelegate: class {
    func didPressUpvote(at index: Int)
    func didPressComments(at index: Int)
    func didPressExpand(at index: Int)
    func didPressAuthor(at index: Int)
    func didPressReblogAuthor(at index: Int)
}

class FeedTabMediator: NSObject {
    private let feedArticleTableViewCellIdentifier = FeedArticleTableViewCell.reuseIdentifier!
    
    private var selectedIndex: IndexPath?
    
    var array = [IndexPath]()
    
    //MARK: Module properties
    weak var tableView: UITableView!
    weak var feedTabPresenter: FeedTabPresenterProtocol!
    
    func configure(tableView: UITableView) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let nib = UINib(nibName: feedArticleTableViewCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: feedArticleTableViewCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        self.tableView = tableView

    }
    
    //MARK: Delegate
    weak var delegate: FeedTabMediatorDelegate?
    
    
    //MARK: Cell configure
    private func configureArticleCell(_ cell: FeedArticleTableViewCell, with viewModel: FeedArticleViewModel?) {
        guard let viewModel = viewModel else {return}
        cell.authorName = viewModel.authorName
        cell.authorAvatarUrl = viewModel.authorAvatarUrl
        cell.articleTitle = viewModel.articleTitle
        cell.reblogAuthorName = viewModel.reblogAuthorName
        cell.theme = viewModel.theme
        cell.articleImageUrl = viewModel.articleImageUrl
        cell.articleBody = viewModel.articleBody
        cell.upvoteAmount = viewModel.upvoteAmount
        cell.commentsAmount = viewModel.commentsAmount
        cell.didUpvote = viewModel.didUpvote
        cell.didComment = viewModel.didComment
    }
}


//MARK: UITableViewDataSource
extension FeedTabMediator: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedTabPresenter.getArticleModels().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedArticleTableViewCellIdentifier) as! FeedArticleTableViewCell
        cell.delegate = self
        
        let viewModel = feedTabPresenter.getArticleModel(at: indexPath.row)
        configureArticleCell(cell, with: viewModel)
                
        return cell
    }
}


//MARK: UITableViewDelegate
extension FeedTabMediator: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let selectedIndex = self.selectedIndex, selectedIndex == indexPath else {
            return FeedArticleTableViewCell.minimizedHeight
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let selectedIndex = self.selectedIndex, selectedIndex == indexPath else {
            return FeedArticleTableViewCell.minimizedHeight
        }

        return UITableViewAutomaticDimension
    }
}


//MARK: FeedArticleTableViewCellDelegate
extension FeedTabMediator: FeedArticleTableViewCellDelegate {
    func didPressCommentsButton(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        delegate?.didPressComments(at: indexPath.row)
    }
    
    func didPressUpvoteButton(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        delegate?.didPressUpvote(at: indexPath.row)
    }
    
    func didPressExpandButton(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        self.selectedIndex = indexPath
        delegate?.didPressExpand(at: indexPath.row)
    }
    
    func didPressAuthor(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        delegate?.didPressAuthor(at: indexPath.row)
    }
    
    func didPressReblogAuthor(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        delegate?.didPressReblogAuthor(at: indexPath.row)
    }
}
