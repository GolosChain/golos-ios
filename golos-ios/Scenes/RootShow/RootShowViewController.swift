//
//  RootShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 02.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
protocol RootShowDisplayLogic: class {
//    func displayPosts(fromViewModel viewModel: RootShowModels.Items.ViewModel)
}

class RootShowViewController: GSBaseViewController {
    // MARK: - Properties
    var interactor: RootShowBusinessLogic?
    var router: (NSObjectProtocol & RootShowRoutingLogic & RootShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView!
    
    
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
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   RootShowInteractor()
        let presenter               =   RootShowPresenter()
        let router                  =   RootShowRouter()
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(stateDidChange(_:)), name: NSNotification.Name.appStateChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.isStatusBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.view.tune()
        self.circularProgressBarView.startAnimation()
        
        // End progress bar animation
        self.circularProgressBarView.endAnimationCompletion = { [weak self] in
            // Router
            self?.router?.routeToNextScene()
        }
        
        // API 'get_discussions_by_hot'
        if !AppSettings.instance().startWithWelcomeScene {
//            let requestModel = RootShowModels.Items.RequestModel()
//            self.interactor?.loadPosts(withRequestModel: requestModel)
        }
    }
    
    @objc
    private func stateDidChange(_ notification: Notification) {
        AppSettings.instance().setStartWithWelcomeScene(true)
        
        self.navigationController?.viewControllers.removeLast((self.navigationController?.viewControllers.count)! - 1)
        self.loadViewSettings()
    }

    
    // MARK: - Actions
    @IBAction func unwindFromLogInShowScene(segue: UIStoryboardSegue) {
        if segue.source.isKind(of: LogInShowViewController.self) {
            AppSettings.instance().setStartWithWelcomeScene(false)

            self.navigationController?.viewControllers.removeLast((self.navigationController?.viewControllers.count)! - 1)
            self.loadViewSettings()
        }
    }
}


// MARK: - RootShowDisplayLogic
extension RootShowViewController: RootShowDisplayLogic {
    func displayPosts(fromViewModel viewModel: RootShowModels.Items.ViewModel) {
//        if let error = viewModel.error {
//            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
//        }
//
//        self.circularProgressBarView.endAnimation()
//        Logger.log(message: "Animation did stop.", event: .severe)
    }
}
