//
//  AnswersFeedMediator.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol AnswersFeedMediatorDelegate: class {
    func didScroll(tableView: UITableView)
}

class AnswersFeedMediator: NSObject {
    
    // MARK: Module properties
    weak var presenter: AnswersFeedPresenterProtocol!
    weak var tableView: UITableView!
    
    // MARK: Delegate
    weak var delegate: AnswersFeedMediatorDelegate?
    
    func configure(tableView: UITableView) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let nib = UINib(nibName: AnswersFeedTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AnswersFeedTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
}

extension AnswersFeedMediator: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getAnswersViewModels().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter.getAnswersViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswersFeedTableViewCell.reuseIdentifier) as! AnswersFeedTableViewCell
        cell.configure(with: viewModel)
        
        return cell
    }
}

extension AnswersFeedMediator: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(tableView: tableView)
    }
}
