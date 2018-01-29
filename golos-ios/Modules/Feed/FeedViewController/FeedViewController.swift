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
    lazy var presenter: FeedPresenterProtocol = {
        let presenter = FeedPresenter()
        presenter.feedView = self
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
//        UIApplication.shared.statusBarStyle = .lightContent
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//        navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "nav_bar_bg"), for: .default)
//        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.delegate = self

//        transitionCoordinator?.animateAlongsideTransition(in: nil, animation: { (context) in
//            self.navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//        }, completion: nil)
        
//        [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//            self.navigationController.navigationBar.translucent = NO;
//            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//
//            // text color
//            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//
//            // navigation items and bar button items color
//            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//            // background color
//            self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
//            } completion:nil];
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.barTintColor = .white
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        setupPageViewController()
        configureBackButton()
        
        let items = presenter.getFeedTabs().map{HorizontalSelectorItem(title: $0.type.rawValue)}
        
        horizontalSelector.items = items
        horizontalSelector.delegate = self
        
//        navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//        UIColor.init(patternImage: <#T##UIImage#>)
        
        
        
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
        
        mediator.configure(pageViewController: pageViewController)
        mediator.setViewController(at: 0)
    }
}


//MARK: FeedViewProtocol
extension FeedViewController: FeedViewProtocol {
    func didChangeActiveIndex(_ index: Int) {
        horizontalSelector.selectedIndex = index
    }
}


extension FeedViewController: HorizontalSelectorViewDelegate {
    func didChangeSelectedIndex(_ index: Int, previousIndex: Int) {
        mediator.setViewController(at: index, previousIndex: previousIndex)
    }
}

extension FeedViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is FeedViewController {
            navigationController.navigationBar.barTintColor = .red
        }
        
        if viewController is ArticleViewController {
            navigationController.navigationBar.barTintColor = .blue
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("aaaaa")
    }
}
