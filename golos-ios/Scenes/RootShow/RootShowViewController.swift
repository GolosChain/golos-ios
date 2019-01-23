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
class RootShowViewController: GSBaseViewController {
    // MARK: - Properties
    var router: (NSObjectProtocol & RootShowRoutingLogic)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView! {
        didSet {
            // End progress bar animation
            self.circularProgressBarView.endAnimationCompletion = { [weak self] in
                // Router
                self?.router?.routeToNextScene()
            }
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
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController      =   self
        let router              =   RootShowRouter()
        
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
        
        // First create App Settings
        if User.isAnonymous {
            _ = AppSettings.instance()
            AppSettings.instance().setAppThemeDark(false)
            AppSettings.instance().setFeedShowImages(true)
            self.loadViewSettings()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(stateDidChange(_:)), name: NSNotification.Name.appStateChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.isStatusBarHidden = true
        
        // Start Microservices session & store secret key
        if let userNickName = User.current?.nickName {
            MicroservicesManager.startSession(forCurrentUser: userNickName) { errorAPI in
                if let currentVC = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.last as? GSBaseViewController, errorAPI != nil {
                    currentVC.showAlertView(withTitle: "Error", andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
                }
                    
                // API `getOptions`
                else {
                    self.getOptions(completion: { success in
                        if !success {
                            self.setBasicOptions()
                        }
                    })
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isStatusBarHidden = false
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.view.tune()
        self.circularProgressBarView.startAnimation()
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


// MARK: - Microservices
extension RootShowViewController {
    private func setBasicOptions() {
        MicroservicesManager.setBasicOptions(userNickName: User.current?.nickName ?? currentUserNickName!, deviceType: currentDeviceType, isDarkTheme: AppSettings.instance().isAppThemeDark, isFeedShowImages: AppSettings.instance().isFeedShowImages, isSoundOn: AppSettings.instance().isPushNotificationSoundOn, completion: { [weak self] errorAPI in
            guard let strongSelf = self else { return }
            
            if errorAPI != nil {
                strongSelf.showAlertView(withTitle: "Error", andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
            }
            
            else {
                strongSelf.getOptions(completion: { success in
                    strongSelf.loadViewSettings()
                })
            }
        })
    }
    
    private func getOptions(completion: @escaping (Bool) -> Void) {
        MicroservicesManager.getOptions(userNickName: User.current?.nickName ?? currentUserNickName!, deviceType: currentDeviceType, completion: { [weak self] (resultOptions, errorAPI) in
            guard let strongSelf = self else { return }
            
            if errorAPI != nil {
                strongSelf.showAlertView(withTitle: "Error", andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in
                    completion(false)
                })
            }
                
            if let currentVC = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.last as? GSBaseViewController, errorAPI != nil {
                currentVC.showAlertView(withTitle: "Error", andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
            }
                
            // Synchronize 'basic' options
            else if let optionsResult = resultOptions?.result {
                Logger.log(message: "push = \n\t\(optionsResult.push)", event: .debug)
                Logger.log(message: "basic = \n\t\(optionsResult.basic)", event: .debug)
                Logger.log(message: "notify = \n\t\(optionsResult.notify)", event: .debug)
                
                // CoreData: modify AppSettings
                let basic = optionsResult.basic
                AppSettings.instance().update(basic: basic)
                completion(basic.theme != nil && basic.soundOn != nil && basic.feedShowImages != nil)
            }
        })
    }
}
