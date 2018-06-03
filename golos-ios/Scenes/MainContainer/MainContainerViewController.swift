//
//  MainContainerViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class MainContainerViewController: BaseViewController {
    // MARK: - Properties
    lazy var presenter: MainContainerPresenter = {
        let presenter       =   MainContainerPresenter()
        presenter.view      =   self
        
        return presenter
    }()
    
    let mediator = MainContainerMediator()
    var activeViewController: UIViewController!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }
    
    
    // MARK: - Custom Functions
    private func setupUI() {
        let currentState        =   presenter.currentState
        let viewController      =   mediator.getViewController(forState: currentState)
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        activeViewController    =   viewController
    }
    
    private func present(newState: AppState, oldState: AppState) {
        let viewController = mediator.getViewController(forState: newState)
        
        if newState == .loggedIn && oldState == .loggedOut {
            presentViewController(viewController, fromTop: false)
        }
        
        if newState == .loggedOut && oldState == .loggedIn {
            presentViewController(viewController, fromTop: true)
        }
    }
    
    private func presentViewController(_ viewController: UIViewController, fromTop: Bool) {
        addChildViewController(viewController)
        
        if fromTop {
            view.insertSubview(viewController.view, aboveSubview: activeViewController.view)
        }
        
        else {
            view.insertSubview(viewController.view, belowSubview: activeViewController.view)
        }
        
        viewController.didMove(toParentViewController: self)
        
        let startFrame = fromTop
            ? activeViewController.view.frame.offsetBy(dx: 0, dy: -UIScreen.main.bounds.size.height)
            : activeViewController.view.frame
        let finalFrame = fromTop
            ? activeViewController.view.frame
            : activeViewController.view.frame.offsetBy(dx: 0, dy: -UIScreen.main.bounds.size.height)
        
        let movingViewController = fromTop ? viewController : activeViewController
        movingViewController?.view.frame = startFrame
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            movingViewController?.view.frame = finalFrame
        }) { _ in
            self.activeViewController.view.removeFromSuperview()
            self.activeViewController.removeFromParentViewController()
            self.activeViewController = viewController
        }
    }
}


// MARK: - MainContainerView
extension MainContainerViewController: MainContainerView {
    func didChange(newState: AppState, from oldState: AppState) {
        self.present(newState: newState, oldState: oldState)
    }
}
