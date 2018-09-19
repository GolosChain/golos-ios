//
//  SettingsShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 24.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift
import Localize_Swift

// MARK: - Input & Output protocols
protocol SettingsShowDisplayLogic: class {
    func displaySomething(fromViewModel viewModel: SettingsShowModels.Items.ViewModel)
}

class SettingsShowViewController: GSBaseViewController {
    // MARK: - Properties
    var interactor: SettingsShowBusinessLogic?
    var router: (NSObjectProtocol & SettingsShowRoutingLogic & SettingsShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var topLineView: UIView! {
        didSet {
            topLineView.tune(withThemeColorPicker: lightGrayishBlueWhiteColorPickers)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.tune(withThemeColorPicker: whiteBlackColorPickers)
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.tune(withThemeColorPicker: lightGrayishBlueWhiteColorPickers)
        }
    }
    
    @IBOutlet var viewsCollection: [UIView]! {
        didSet {
            _ = viewsCollection.map({ $0.tune(withThemeColorPicker: whiteBlackColorPickers )})
        }
    }
    
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            versionLabel.tune(withText:         String(format: "Golos %@ iOS %@", "for".localized(), appVersion),
                              hexColors:        darkGrayWhiteColorPickers,
                              font:             UIFont(name: "SFProDisplay-Regular", size: 10.0),
                              alignment:        .center,
                              isMultiLines:     false)
        }
    }
    
    @IBOutlet weak var languageButton: UIButton! {
        didSet {
            languageButton.tune(withTitle:      "Interface Language".localized(),
                                hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                font:           UIFont(name: "SFProDisplay-Regular", size: 14.0),
                                alignment:      .left)
        }
    }
    
    
    @IBOutlet weak var logOutButton: UIButton! {
        didSet {
            logOutButton.tune(withTitle:        "Exit Verb".localized(),
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFProDisplay-Regular", size: 14.0),
                              alignment:        .left)
        }
    }
    
    @IBOutlet weak var editUserProfileButton: UIButton! {
        didSet {
            editUserProfileButton.tune(withTitle:       "Edit Profile Title".localized(),
                                       hexColors:       [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                       font:            UIFont(name: "SFProDisplay-Regular", size: 14.0),
                                       alignment:       .left)
        }
    }
    
    @IBOutlet weak var notificationsButton: UIButton! {
        didSet {
            notificationsButton.tune(withTitle: "Remote Notifications Title".localized(),
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFProDisplay-Regular", size: 14.0),
                              alignment:        .left)
        }
    }
    
    @IBOutlet var constraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = constraintsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
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
        let interactor              =   SettingsShowInteractor()
        let presenter               =   SettingsShowPresenter()
        let router                  =   SettingsShowRouter()
        
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
        
        self.localizeTitles()
        self.loadViewSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .default

        NotificationCenter.default.addObserver(self, selector: #selector(localizeTitles), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.view.tune()

//        let requestModel    =   SettingsShowModels.Items.RequestModel()
//        interactor?.doSomething(withRequestModel: requestModel)
    }
    
    
    // MARK: - Actions
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        let actionSheet     =   UIAlertController(title: nil, message: "Interface Language".localized(), preferredStyle: .actionSheet)
        
        for language in Localize.availableLanguages() {
            let displayName     =   Localize.displayNameForLanguage(language).uppercaseFirst
            
            let languageAction  =   UIAlertAction(title: displayName, style: .default, handler: { _ in
                Localize.setCurrentLanguage(language)
            })
            
            actionSheet.addAction(languageAction)
        }
        
        let cancelAction = UIAlertAction(title: "ActionCancel".localized(), style: .cancel, handler: { _ in })
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Exit", andMessage: "Are Your Sure?", needCancel: true, completion: { [weak self] success in
            if success {
                self?.router?.routeToLoginShowScene()
            }
        })
    }
    
    @IBAction func editUserProfileButtonTapped(_ sender: UIButton) {
        self.router?.routeToSettingsUserProfileEditScene()
    }

    @IBAction func notificationsButtonTapped(_ sender: UIButton) {
        self.router?.routeToSettingsNotificationsScene()
    }
    
    // Set titles with support App language
    @objc override func localizeTitles() {
        self.title                  =   "Settings".localized()
        self.versionLabel.text      =   String(format: "Golos %@ iOS %@", "for".localized(), appVersion)
        
        self.logOutButton.setTitle("Exit Verb".localized(), for: .normal)
        self.languageButton.setTitle("Interface Language".localized(), for: .normal)
        self.editUserProfileButton.setTitle("Edit Profile Title".localized(), for: .normal)
        self.notificationsButton.setTitle("Remote Notifications Title".localized(), for: .normal)
    }
}


// MARK: - SettingsShowDisplayLogic
extension SettingsShowViewController: SettingsShowDisplayLogic {
    func displaySomething(fromViewModel viewModel: SettingsShowModels.Items.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
}
