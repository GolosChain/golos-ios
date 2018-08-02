//
//  PostShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 31.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
protocol PostShowDisplayLogic: class {
    func displayLoadContent(fromViewModel viewModel: PostShowModels.Post.ViewModel)
}

class PostShowViewController: GSBaseViewController {
    // MARK: - Properties
    var interactor: PostShowBusinessLogic?
    var router: (NSObjectProtocol & PostShowRoutingLogic & PostShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.tune()
        }
    }
    
    @IBOutlet weak var navbarView: UIView! {
        didSet {
            navbarView.tune()
            navbarView.add(shadow: true, onside: .bottom)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:           "",
                            hexColors:          veryDarkGrayWhiteColorPickers,
                            font:               UIFont(name: "SFUIDisplay-Medium", size: 15.0 * widthRatio),
                            alignment:          .left,
                            isMultiLines:       true)
        }
    }
    
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.tune(withText:           "",
                           hexColors:          veryDarkGrayWhiteColorPickers,
                           font:               UIFont(name: "SFUIDisplay-Regular", size: 13.0 * widthRatio),
                           alignment:          .left,
                           isMultiLines:       true)
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet weak var coverImageViewHeight: NSLayoutConstraint! {
        didSet {
            coverImageViewHeight.constant *= heightRatio
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
        let viewController          =   self
        let interactor              =   PostShowInteractor()
        let presenter               =   PostShowPresenter()
        let router                  =   PostShowRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
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
        
        UIApplication.shared.statusBarStyle = .default
        
        // Load Posts
        self.loadContent()
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.titleLabel.text    =   "d fkajk jdakjd kajsdjf gsfshd fsdjkh jh"
        // jaj hajkjH AH KDJAJKH AHDA JSHD AH DAJD JAHAHJK HKAJ  HAK JHAKD AKSHD Kahd jahksjhkhkKJHKJHKjhgd kakjasdh djkha dhakh"
        
        self.textLabel.text     =   "jaj hajkjH AH KDJAJKH AHDA JSHD AH DAJD JAHAHJK HKAJ  HAK JHAKD AKSHD Kahd jahksjhkhkKJHKJHKjhgd kakjasdh djkha dhakh"
        
        self.coverImageViewHeight.constant = 0
    }
}


// MARK: - PostShowDisplayLogic
extension PostShowViewController: PostShowDisplayLogic {
    func displayLoadContent(fromViewModel viewModel: PostShowModels.Post.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
}


// MARK: - Load data from Blockchain by API
extension PostShowViewController {
    private func loadContent() {
        let contentRequestModel = PostShowModels.Post.RequestModel()
        interactor?.loadContent(withRequestModel: contentRequestModel)
    }
}


// MARK: - Fetch data from CoreData
extension PostShowViewController {
    // User Profile
    private func fetchContent() {

    }
}
