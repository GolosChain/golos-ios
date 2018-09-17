//
//  ContainerView.swift
//  Golos
//
//  Created by msm72 on 14.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

enum AnimationDirection {
    case fromLeftToRight
    case fromRightToLeft
}

protocol ContainerViewSupport {
    var containerView: GSContainerView! { get set }
}

class GSContainerView: UIView {
    // MARK: - Properties
    private let screenWidth: CGFloat = UIScreen.main.bounds.width * widthRatio
    
    weak var mainVC: GSBaseViewController?
    
    var viewControllers: [GSTableViewController]?
    var animationDirection: AnimationDirection?
    
    private var currentIndex: Int = 0 {
        didSet {
            self.animationDirection = oldValue < currentIndex ? .fromRightToLeft : .fromLeftToRight
        }
    }
    
    var activeVC: GSTableViewController? {
        didSet {
            guard oldValue != nil else {
                self.updateActiveViewController()
                
                return
            }
            
            self.remove(inactiveViewController: oldValue)
        }
    }

    
    // MARK: - Custom Functions
    func setActiveViewController(index: Int) {
        self.currentIndex   =   index
//        self.activeVC       =   self.viewControllers![index]
    }
    
    func remove(inactiveViewController: GSTableViewController?) {
        if let inactiveVC = inactiveViewController {
            UIView.animate(withDuration: 0.3, animations: {
                inactiveVC.view.transform = CGAffineTransform.identity
            }, completion: { _ in
                inactiveVC.willMove(toParentViewController: nil)
                inactiveVC.view.removeFromSuperview()
                inactiveVC.removeFromParentViewController()
                
                self.updateActiveViewController()
            })
        }
    }
    
    func updateActiveViewController() {
        if let activeViewController = self.activeVC {
            self.add(activeViewController: activeViewController)
            self.viewControllers![currentIndex] = activeViewController

            if self.animationDirection != nil {
                UIView.animate(withDuration: 0.3, animations: {
                    self.activeVC!.view.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    private func add(activeViewController: UIViewController) {
        if let mainViewController = self.mainVC, let viewController = mainViewController as? ContainerViewSupport {
            mainViewController.addChildViewController(activeViewController)
            
            self.activeVC!.view.frame       =   viewController.containerView.bounds
            self.activeVC!.view.transform   =   CGAffineTransform(translationX: screenWidth * (self.animationDirection == .fromRightToLeft ? 1 : -1), y: 0.0)

            viewController.containerView.addSubview(activeVC!.view)
            activeVC!.didMove(toParentViewController: mainViewController)
        }
    }
}
