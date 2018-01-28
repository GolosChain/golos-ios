//
//  ProfileMediator.swift
//  Golos
//
//  Created by Grigory on 28/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileMediatorDelegate: class {
    func tableViewDidScroll(_ tableView: UITableView)
    
    func heightForSegmentedControlHeight() -> CGFloat
}

class ProfileMediator: NSObject {
    weak var profilePresenter: ProfilePresenterProtocol!
    
    weak var tableView: UITableView!
    
    weak var delegate: ProfileMediatorDelegate?
    
    func configure(tableView: UITableView) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
//        let nib = UINib(nibName: feedArticleTableViewCellIdentifier, bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: feedArticleTableViewCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
}


//MARK: UITableViewDataSource
extension ProfileMediator: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}


//MARK: UITableViewDelegate
extension ProfileMediator: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        delegate?.tableViewDidScroll(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0, let delegate = delegate else {
            return 0
        }
        
        return delegate.heightForSegmentedControlHeight()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let horizontalSelector = ProfileHorizontalSelectorView()
        return horizontalSelector
    }
}
