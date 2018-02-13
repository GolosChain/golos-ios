//
//  ProfileMediator.swift
//  Golos
//
//  Created by Grigory on 28/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileMediatorDelegate: class {
//    func tableViewDidScroll(_ tableView: UITableView)
//    
//    func heightForSegmentedControlHeight() -> CGFloat
//    func didSelect(tab: ProfileFeedTab)
    
    func didPressUpvote(at index: Int)
    func didPressComments(at index: Int)
    func didPressAuthor(at index: Int)
    func didPressReblogAuthor(at index: Int)
}

class ProfileMediator: NSObject {
    private let feedArticleTableViewCellIdentifier = FeedArticleTableViewCell.reuseIdentifier!
    
    weak var profilePresenter: ProfilePresenterProtocol!
    
    weak var tableView: UITableView!
    
    weak var delegate: ProfileMediatorDelegate?
    
    func configure(tableView: UITableView) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let nib = UINib(nibName: feedArticleTableViewCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: feedArticleTableViewCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
}


// MARK: UITableViewDataSource
extension ProfileMediator: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        
        return profilePresenter.getFeedModels().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedArticleTableViewCellIdentifier) as! FeedArticleTableViewCell
        cell.delegate = self
        
        let viewModel = profilePresenter.getArticleModel(at: indexPath.row)
        cell.configure(with: viewModel)
        cell.isNeedExpand = false
        
        return cell
    }
}


// MARK: UITableViewDelegate
extension ProfileMediator: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        let horizontalSelector = ProfileHorizontalSelectorView()
        horizontalSelector.delegate = self
        return horizontalSelector
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FeedArticleTableViewCell.minimizedHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return FeedArticleTableViewCell.minimizedHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}


// MARK: FeedArticleTableViewCellDelegate
extension ProfileMediator: FeedArticleTableViewCellDelegate {
    func didPressCommentsButton(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        delegate?.didPressComments(at: indexPath.row)
    }
    
    func didPressUpvoteButton(at cell: FeedArticleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        delegate?.didPressUpvote(at: indexPath.row)
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

extension ProfileMediator: ProfileHorizontalSelectorViewDelegate {
    func didSelect(profileFeedTab: ProfileFeedTab) {
    }
}
