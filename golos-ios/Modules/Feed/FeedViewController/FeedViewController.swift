//
//  FeedViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    //MARK: UI Outlets
    @IBOutlet weak var horizontalSelector: HorizontalSelectorView!
    
    
    //MARK: UI properties
    let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
    
    
    //MARK: Module properties
    lazy var presenter: FeedPresenter = {
        let presenter = FeedPresenter()
        return presenter
    }()
    
    lazy var mediator: FeedMediator = {
        let mediator = FeedMediator()
        mediator.presenter = self.presenter
        return mediator
    }()
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        setupPageViewController()
        
        let items = presenter.getFeedTabs().map{HorizontalSelectorItem(title: $0.type.rawValue)}
        
        horizontalSelector.items = items 
        navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//        if let navigationBar = navigationController?.navigationBar {
//            let dropDownMenu = NavigationDropDownView()
//            dropDownMenu.frame = CGRect(x: 0,
//                                        y: 0,
//                                        width: navigationBar.bounds.width,
//                                        height: navigationBar.bounds.height)
//            navigationItem.titleView = dropDownMenu
//        }
        
    //        let dropDownViewController = DropDownViewController()
    //        dropDownViewController.view.frame = dropDownViewController.view.frame.offsetBy(dx: 0, dy: 100)
    //        navigationController?.addChildViewController(dropDownViewController)
    //        navigationController?.view.addSubview(dropDownViewController.view)
    //        dropDownViewController.didMove(toParentViewController: self)
        
    }
    
    private func setupPageViewController() {
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: horizontalSelector.bottomAnchor).isActive = true
        pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let vc1 = FeedTabViewController()
        vc1.feedType = presenter.selectedFeedTab?.type ?? .hot
        
        pageViewController.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
        
        pageViewController.dataSource = mediator
        pageViewController.delegate = mediator
    }
}


//MARK: FeedMediatorDelegate
extension FeedViewController: FeedMediatorDelegate {
    func didChangeFeedTab(_ feedTab: FeedTab) {
        
    }
}
