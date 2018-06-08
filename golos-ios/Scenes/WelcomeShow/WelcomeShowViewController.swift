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
protocol WelcomeShowDisplayLogic: class {}

class WelcomeShowViewController: BaseViewController {
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
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    
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
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.log(message: "Success", event: .severe)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        title = ""
        configureBackButton()
        enterButton.setBlueButtonRoundEdges()
        registerButton.setBorderButtonRoundEdges()
        moreInfoButton.setTitleColor(UIColor.Project.buttonTextGray, for: .normal)
        
        pageControl.numberOfPages = scrollStrings.count
        setupScrollView()
    }
    
    private func setupScrollView() {
        Logger.log(message: "Success", event: .severe)
        
        scrollView.delegate = self
        
        for string in self.scrollStrings {
            let label               =   UILabel()
            label.font              =   Fonts.shared.regular(with: 16.0)
            label.textColor         =   UIColor.Project.textBlack
            label.text              =   string
            label.numberOfLines     =   0
            label.textAlignment     =   .center
            
            scrollView.addSubview(label)
            scrollLabels.append(label)
        }
    }
    
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.log(message: "Success", event: .severe)
        
        for (index, label) in scrollLabels.enumerated() {
            let pointX                  =   scrollView.bounds.size.width * CGFloat(index)
            var scrollViewBounds        =   scrollView.bounds
            
            scrollViewBounds.origin.x   =   pointX
            label.frame                 =   scrollViewBounds
        }
        
        scrollView.contentSize          =   CGSize(width: scrollView.bounds.size.width * CGFloat(scrollLabels.count),
                                                   height: scrollView.bounds.size.height)
    }
    
    
    // MARK: - Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        router?.routeToLoginShowScene()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        router?.showRegisterFormOnline()
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        router?.showMoreInfoPageOnline()
    }
}


// MARK: - WelcomeShowDisplayLogic
extension WelcomeShowViewController: WelcomeShowDisplayLogic {}


// MARK: - UIScrollViewDelegate
extension WelcomeShowViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.bounds.size.width
        let pageNumber = scrollView.contentOffset.x / scrollViewWidth
        
        pageControl.currentPage = Int(pageNumber)
        
        Logger.log(message: "\(scrollView.contentOffset.x / scrollViewWidth)", event: .verbose)
        Logger.log(message: "\(scrollView.contentOffset)", event: .verbose)
    }
}
