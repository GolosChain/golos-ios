//
//  MainContainerViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class MainContainerViewController: GSBaseViewController {
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
//        let currentState        =   presenter.currentState
        let viewController      =   mediator.getViewController()
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        activeViewController    =   viewController
        
        if let tabbar = viewController as? GSTabBarController {
            tabbar.delegate     =   self
        }
    }
    
    private func present(newState: AppState, oldState: AppState) {
        let viewController = mediator.getViewController()
        
        if newState == .loggedIn && oldState == .loggedOut {
            presentViewController(viewController, fromTop: false)
        }
        
        if newState == .loggedOut && oldState == .loggedIn {
            presentViewController(viewController, fromTop: true)
        }
    }
    
    private func presentViewController(_ viewController: UIViewController, fromTop: Bool) {
        addChild(viewController)
        
        if fromTop {
            view.insertSubview(viewController.view, aboveSubview: activeViewController.view)
        }
        
        else {
            view.insertSubview(viewController.view, belowSubview: activeViewController.view)
        }
        
        viewController.didMove(toParent: self)
        
        let startFrame = fromTop ?  activeViewController.view.frame.offsetBy(dx: 0, dy: -UIScreen.main.bounds.size.height) :
                                    activeViewController.view.frame
        
        let finalFrame = fromTop ?  activeViewController.view.frame :
                                    activeViewController.view.frame.offsetBy(dx: 0, dy: -UIScreen.main.bounds.size.height)
        
        let movingViewController = fromTop ? viewController : activeViewController
        
        movingViewController?.view.frame = startFrame
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            movingViewController?.view.frame = finalFrame
        }) { _ in
            self.activeViewController.view.removeFromSuperview()
            self.activeViewController.removeFromParent()
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


// MARK: - UITabBarControllerDelegate
extension MainContainerViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 0: Lenta, 1: Search, 2: Add Post, 3: Notifications, 4: Profile
        guard User.isAnonymous else {
            return true
        }
        
        switch viewController.tabBarItem.tag {
        case 2, 4:
            self.showAlertView(withTitle: "Info", andMessage: "Please Login in App", needCancel: true, completion: { success in
                if success {
                    NotificationCenter.default.post(name:       NSNotification.Name.appStateChanged,
                                                    object:     nil,
                                                    userInfo:   nil)
                }
            })
            
        default:
            let fromView: UIView    =   tabBarController.selectedViewController!.view
            let toView: UIView      =   viewController.view
            
            if fromView == toView {
                return false
            }
            
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionCrossDissolve) { _ in }
            
            return true
        }

        return false
    }
}
