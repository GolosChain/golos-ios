//
//  AnswersFeedViewController.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class AnswersFeedViewController: UIViewController {
    
    // MARK: Outlets properties
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Module properties
    lazy var presenter: AnswersFeedPresenterProtocol = {
        let presenter = AnswersFeedPresenter()
        presenter.answersFeedView = self
        return presenter
    }()
    
    lazy var mediator: AnswersFeedMediator = {
        let mediator = AnswersFeedMediator()
        mediator.presenter = self.presenter
        mediator.delegate = self
        return mediator
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetchAnswers()
    }
    
    // MARK: SetupUI
    private func setupUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        mediator.configure(tableView: self.tableView)
    }
}

extension AnswersFeedViewController: AnswersFeedViewProtocol {
    
}

extension AnswersFeedViewController: AnswersFeedMediatorDelegate {
    func didScroll(tableView: UITableView) {
        delegate?.didScrollItem(self)
    }
}
