//
//  WelcomeShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 08.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
class WelcomeShowViewController: GSBaseViewController {
    // MARK: - Properties
    var scrollLabels    =   [UILabel]()
    
    let scrollStrings   =   [
                                "Blog Platform 0".localized(),
                                "Blog Platform 1".localized(),
                                "Blog Platform 2".localized(),
                                "Blog Platform 3".localized()
                            ]

    var router: (NSObjectProtocol & WelcomeShowRoutingLogic & WelcomeShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var welcomeLabel: UILabel! {
        didSet {
            welcomeLabel.tune(withText:         welcomeLabel.text ?? "XXX",
                              hexColors:        blackWhiteColorPickers,
                              font:             UIFont.init(name: "SFProDisplay-Regular", size: 25.0 * widthRatio),
                              alignment:        .center,
                              isMultiLines:     false)
        }
    }
    
    @IBOutlet weak var inGolosLabel: UILabel! {
        didSet {
            inGolosLabel.tune(withText:         inGolosLabel.text ?? "XXX",
                              hexColors:        blackWhiteColorPickers,
                              font:             UIFont.init(name: "SFProDisplay-Regular", size: 40.0 * widthRatio),
                              alignment:        .center,
                              isMultiLines:     false)
        }
    }
    
    @IBOutlet weak var titlesScrollView: UIScrollView! {
        didSet {
            titlesScrollView.delegate   =   self
            
            for string in self.scrollStrings {
                let titleLabel              =   UILabel(frame: .zero)
                
                titleLabel.tune(withText:       string,
                                hexColors:      blackWhiteColorPickers,
                                font:           UIFont.init(name: "SFProDisplay-Regular", size: 16.0 * widthRatio),
                                alignment:      .center,
                                isMultiLines:   true)
                
                titlesScrollView.addSubview(titleLabel)
                scrollLabels.append(titleLabel)
            }
        }
    }
    
    @IBOutlet weak var titlesPageControl: UIPageControl! {
        didSet {
            titlesPageControl.numberOfPages = scrollStrings.count
        }
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var welcomeButton: UIButton! {
        didSet {
            self.welcomeButton.tune(withTitle:      "More Info".localized(),
                                    hexColors:      [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                    font:           UIFont(name: "SFProDisplay-Regular", size: 14.0),
                                    alignment:      .center)
        }
    }

    @IBOutlet var heightConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
        }
    }
    
    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController      =   self
        let router              =   WelcomeShowRouter()
        
        viewController.router   =   router
        router.viewController   =   viewController
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViewSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.log(message: "Success", event: .severe)
        
        self.hideNavigationBar()
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.log(message: "Success", event: .severe)
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.view.tune()
    }
    
    fileprivate func showNext(_ page: Int?) {
        let scrollViewWidth     =   titlesScrollView.bounds.size.width
        let pageNumber          =   titlesScrollView.contentOffset.x / scrollViewWidth
        
        titlesPageControl.currentPage = page ?? Int(pageNumber)
        
        if let currentPage = page {
            self.titlesScrollView.scrollRectToVisible(CGRect(origin:    CGPoint(x: scrollViewWidth * CGFloat(currentPage), y: 0.0),
                                                             size:      titlesScrollView.frame.size), animated: true)
        }
        
        Logger.log(message: "\(titlesScrollView.contentOffset.x / scrollViewWidth)", event: .verbose)
        Logger.log(message: "\(titlesScrollView.contentOffset)", event: .verbose)
    }
    
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.log(message: "Success", event: .severe)
        
        self.titlesScrollView.layoutIfNeeded()

        for (index, label) in scrollLabels.enumerated() {
            let pointX                  =   titlesScrollView.bounds.size.width * CGFloat(index)
            var scrollViewBounds        =   titlesScrollView.bounds
            
            scrollViewBounds.origin.x   =   pointX
            label.frame                 =   scrollViewBounds
        }
        
        titlesScrollView.contentSize    =   CGSize(width:   titlesScrollView.bounds.size.width * CGFloat(scrollLabels.count),
                                                   height:  titlesScrollView.bounds.size.height)
        
        // Tune buttons
        loginButton.setTitle("Log In".localized(), for: .normal)
        loginButton.setBlueButtonRoundEdges()

        signInButton.setTitle("Sign In".localized(), for: .normal)
        signInButton.setBorderButtonRoundEdges()
    }
    
    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        router?.routeToLoginShowScene()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.openExternalLink(byURL: GolosWebPage.registration.rawValue)
    }
    
    @IBAction func welcomeButtonPressed(_ sender: Any) {
        self.openExternalLink(byURL: GolosWebPage.welcome.rawValue)
    }
    
    @IBAction func handlerSelectNewPage(_ sender: UIPageControl) {
        self.showNext(sender.currentPage)
    }
}


// MARK: - UIScrollViewDelegate
extension WelcomeShowViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.showNext(nil)
    }
}
