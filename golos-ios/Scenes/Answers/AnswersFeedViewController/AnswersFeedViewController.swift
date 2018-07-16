//
//  AnswersFeedViewController.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class AnswersFeedViewController: UIViewController {
    // MARK: - Properties
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
    

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Success", event: .severe)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetchAnswers()
    }
    
    
    // MARK: - Custom Functions
    private func setupUI() {
        Logger.log(message: "Success", event: .severe)

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        mediator.configure(tableView: self.tableView)
    }
}


// MARK: - AnswersFeedViewProtocol
extension AnswersFeedViewController: AnswersFeedViewProtocol {
    
}


// MARK: - AnswersFeedMediatorDelegate
extension AnswersFeedViewController: AnswersFeedMediatorDelegate {
    func didScroll(tableView: UITableView) {
        Logger.log(message: "Success", event: .severe)
        
//        delegate?.didScrollItem(self)
    }
}
