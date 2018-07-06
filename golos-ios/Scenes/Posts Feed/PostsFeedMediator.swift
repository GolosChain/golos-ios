//
//  PostsFeedMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

protocol PostsFeedMediatorDelegate: class {
    func didScroll(tableView: UITableView)
    func didPressUpvote(at index: Int)
    func didPressComments(at index: Int)
    func didPressExpand(at index: Int)
    func didPressAuthor(at index: Int)
    func didPressReblogAuthor(at index: Int)
    func didSelectArticle(at index: Int)
    func didStartLoadingNextPage()
}

extension PostsFeedMediatorDelegate {
    func didScroll(tableView: UITableView) {}
}

class PostsFeedMediator: NSObject {
    private let feedArticleTableViewCellIdentifier = FeedArticleTableViewCell.reuseIdentifier!
    
    private var selectedIndex: IndexPath?
    
    var array = [IndexPath]()
    
    // MARK: - Delegate
    weak var delegate: PostsFeedMediatorDelegate?
    
    // MARK: Module properties
    weak var tableView: UITableView!
    weak var postsFeedPresenter: PostsFeedPresenterProtocol!
    
    func configure(tableView: UITableView) {
        // FIXME: - DELETE AFTER TEST (INFINITY LOADER)
//        tableView.tableFooterView   =   UIView(frame: CGRect.zero)
        let nib = UINib(nibName: feedArticleTableViewCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: feedArticleTableViewCellIdentifier)
        
        tableView.dataSource        =   self
        tableView.delegate          =   self

        self.tableView = tableView
    }
}


// MARK: UITableViewDataSource
extension PostsFeedMediator: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsFeedPresenter.getDisplayedPosts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        =   tableView.dequeueReusableCell(withIdentifier: feedArticleTableViewCellIdentifier) as! FeedArticleTableViewCell
        cell.delegate   =   self
        
        let displayedModel = postsFeedPresenter.getDisplayedPost(byIndex: indexPath.row)
        cell.configure(withDisplayedModel: displayedModel)
        
        // Pagination
        if indexPath.row == postsFeedPresenter.getDisplayedPosts().count - Int(loadDataLimit / 2) {
            DispatchQueue.main.async {
                self.postsFeedPresenter.loadNext(withType: self.postsFeedPresenter.getFeedPostsType())
//                self.delegate?.didStartLoadingNextPage()
            }
        }
                
        return cell
    }
}


// MARK: - UITableViewDelegate
extension PostsFeedMediator: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let displayedModel  =   postsFeedPresenter.getDisplayedPost(byIndex: indexPath.row)
        let isImage         =   displayedModel?.imagePictureURL == nil ? false : true
        
        return FeedArticleTableViewCell.height(withImage: isImage)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let displayedModel  =   postsFeedPresenter.getDisplayedPost(byIndex: indexPath.row)
        let isImage         =   displayedModel?.imagePictureURL == nil ? false : true
        
        return FeedArticleTableViewCell.height(withImage: isImage)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectArticle(at: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard cell is FeedArticleTableViewCell else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard cell is FeedArticleTableViewCell else {
            return
        }
    }
}


// MARK: FeedArticleTableViewCellDelegate
extension PostsFeedMediator: FeedArticleTableViewCellDelegate {
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
