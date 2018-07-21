////
////  FeedViewController.swift
////  Golos
////
////  Created by Grigory Serebryanyy on 15/01/2018.
////  Copyright © 2018 golos. All rights reserved.
////
//
//import UIKit
//import GoloSwift
//
//class FeedViewController: UIViewController {
//    // MARK: - Properties
//    let pageViewController = UIPageViewController(transitionStyle:          .scroll,
//                                                  navigationOrientation:    .horizontal,
//                                                  options:                  nil)
//
//    lazy var presenter: FeedPresenterProtocol = {
//        let presenter = FeedPresenter()
//        presenter.feedView = self
//       
//        return presenter
//    }()
//    
//    lazy var mediator: FeedMediator = {
//        let mediator = FeedMediator()
//        mediator.presenter = self.presenter
//        mediator.delegate = self
//       
//        return mediator
//    }()
//
//    
//    // MARK: - IBOutlets
//    @IBOutlet weak var horizontalSelector: HorizontalSelectorView!
//    
//    
//    // MARK: - Class Initialization
//    deinit {
//        Logger.log(message: "Success", event: .severe)
//    }
//    
//
//    // MARK: - Class Functions
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Logger.log(message: "Success", event: .severe)
//        
//        setupUI()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        UIApplication.shared.statusBarStyle = .lightContent
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
//    
//   // MARK: - Custom Functions
//    private func setupUI() {
//        Logger.log(message: "Success", event: .severe)
//
//        setupPageViewController()
//        configureBackButton()
//        
//        let selectorItems = presenter.getPostsFeedTypeArray().map ({ HorizontalSelectorItem(title: $0.caseTitle()) })
//        
//        horizontalSelector.items        =   selectorItems
//        horizontalSelector.delegate     =   self
//        
//        // TODO: - DELETE AFTER TEST
////        if let navigationBar = navigationController?.navigationBar {
////            let dropDownMenu = NavigationDropDownView()
////
////            dropDownMenu.frame = CGRect(x:          0,
////                                        y:          0,
////                                        width:      navigationBar.bounds.width,
////                                        height:     navigationBar.bounds.height)
////
////            navigationItem.titleView = dropDownMenu
////        }
//        
//    //        let dropDownViewController = DropDownViewController()
//    //        dropDownViewController.view.frame = dropDownViewController.view.frame.offsetBy(dx: 0, dy: 100)
//    //        navigationController?.addChildViewController(dropDownViewController)
//    //        navigationController?.view.addSubview(dropDownViewController.view)
//    //        dropDownViewController.didMove(toParentViewController: self)
//        
//    }
//    
//    private func setupPageViewController() {
//        Logger.log(message: "Success", event: .severe)
//
//        addChildViewController(pageViewController)
//        view.addSubview(pageViewController.view)
//        pageViewController.didMove(toParentViewController: self)
//        
//        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        pageViewController.view.topAnchor.constraint(equalTo: horizontalSelector.bottomAnchor).isActive = true
//        pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        
//        mediator.configure(pageViewController: pageViewController)
//        mediator.setViewController(at: 0)
//    }
//}
//
//
//// MARK: - FeedMediatorDelegate
//extension FeedViewController: FeedMediatorDelegate {
//    func didChangePage(at index: Int) {
//        Logger.log(message: "Success", event: .severe)
//
//        horizontalSelector.selectedIndex = index
//    }
//}
//
//
//// MARK: - FeedViewProtocol
//extension FeedViewController: FeedViewProtocol {}
//
//
//// MARK: - HorizontalSelectorViewDelegate
//extension FeedViewController: HorizontalSelectorViewDelegate {
//    func didChangeSelectedIndex(_ index: Int, previousIndex: Int) {
//        Logger.log(message: "Success", event: .severe)
//
//        mediator.setViewController(at: index, previousIndex: previousIndex)
//    }
//}
