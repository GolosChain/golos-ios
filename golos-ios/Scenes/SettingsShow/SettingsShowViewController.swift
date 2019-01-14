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
import Amplitude_iOS
import DLRadioButton
import Localize_Swift

// MARK: - Input & Output protocols
protocol SettingsShowDisplayLogic: class {
    func displaySomething(fromViewModel viewModel: SettingsShowModels.Items.ViewModel)
}

class SettingsShowViewController: GSBaseViewController {
    // MARK: - Properties
    var onlinePage: GolosWebPage?
    
    var interactor: SettingsShowBusinessLogic?
    var router: (NSObjectProtocol & SettingsShowRoutingLogic & SettingsShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var welcomeButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var wikiGolosButton: UIButton!
    @IBOutlet weak var voicePowerButton: UIButton!
    @IBOutlet weak var switchAccountButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var editUserProfileButton: UIButton!
    @IBOutlet weak var pushNotificationsButton: UIButton!

    @IBOutlet weak var commonLabel: UILabel!
    
    @IBOutlet weak var viewPicturesSwitch: UISwitch! {
        didSet {
            self.viewPicturesSwitch.isOn        =   AppSettings.isFeedShowImages
            self.viewPicturesSwitch.transform   =   CGAffineTransform(scaleX: widthRatio, y: widthRatio)
        }
    }
    
    @IBOutlet weak var dayImageView: UIImageView! {
        didSet {
            self.dayImageView.image = UIImage(named: AppSettings.isAppThemeDark ? "icon-button-day-normal" : "icon-button-day-selected")
        }
    }
    
    @IBOutlet weak var moonImageView: UIImageView! {
        didSet {
            self.moonImageView.image = UIImage(named: AppSettings.isAppThemeDark ? "icon-button-moon-selected" : "icon-button-moon-normal")
        }
    }

    @IBOutlet weak var dayRadioButton: DLRadioButton! {
        didSet {
            self.dayRadioButton.isSelected  =   !AppSettings.isAppThemeDark
            self.dayRadioButton.iconColor   =   UIColor(hexString: AppSettings.isAppThemeDark ? "#B7B7BA" : "#2F7DFB")
        }
    }
    
    @IBOutlet weak var moonRadioButton: DLRadioButton! {
        didSet {
            self.moonRadioButton.isSelected =   AppSettings.isAppThemeDark
            self.moonRadioButton.iconColor  =   UIColor(hexString: AppSettings.isAppThemeDark ? "#2F7DFB" : "#B7B7BA")
        }
    }
    
    @IBOutlet var radioButtonsCollection: [UIButton]! {
        didSet {
            self.radioButtonsCollection.forEach({
                $0.tune(withTitle:      $0.accessibilityIdentifier!.localized(),
                        hexColors:      [blackWhiteColorPickers, grayWhiteColorPickers, blackWhiteColorPickers, grayWhiteColorPickers],
                        font:           UIFont(name: "SFProDisplay-Regular", size: 14.0),
                        alignment:      .left) })
        }
    }
    
    @IBOutlet weak var languageLabel: UILabel! {
        didSet {
            self.languageLabel.tune(withText:       "Language App".localized(),
                                    hexColors:      veryDarkGrayWhiteColorPickers,
                                    font:           UIFont(name: "SFProDisplay-Regular", size: 14.0),
                                    alignment:      .right,
                                    isMultiLines:   false)
        }
    }
    
    @IBOutlet var actionButtonsCollection: [UIButton]! {
        didSet {
            actionButtonsCollection.forEach({
                $0.tune(withTitle:      "",
                        hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                        font:           UIFont(name: "SFProDisplay-Regular", size: 14.0),
                        alignment:      .left)
            })
        }
    }
    
    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            labelsCollection.forEach({
                $0.tune(withText:       "",
                        hexColors:      darkGrayWhiteColorPickers,
                        font:           UIFont(name: "SFProDisplay-Regular", size: 12.0),
                        alignment:      .left,
                        isMultiLines:   false)
            })
        }
    }
    
    @IBOutlet weak var topLineView: UIView! {
        didSet {
            self.topLineView.tune(withThemeColorPicker: lightGrayishBlueWhiteColorPickers)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.tune(withThemeColorPicker: whiteVeryDarkGrayishRedPickers)
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.tune(withThemeColorPicker: whiteVeryDarkGrayishRedPickers)
        }
    }
    
    @IBOutlet var viewsCollection: [UIView]! {
        didSet {
            self.viewsCollection.forEach({ $0.tune(withThemeColorPicker: whiteVeryDarkGrayishRedPickers )})
        }
    }
    
    @IBOutlet weak var displayModeTitleLabel: UILabel! {
        didSet {
            self.displayModeTitleLabel.tune(withText:       "Display Mode Title".localized(),
                                            hexColors:      veryDarkGrayWhiteColorPickers,
                                            font:           UIFont(name: "SFProDisplay-Medium", size: 14.0),
                                            alignment:      .left,
                                            isMultiLines:   false)
        }
    }
 
    @IBOutlet weak var displayModeViewPicturesTitleLabel: UILabel! {
        didSet {
            self.displayModeViewPicturesTitleLabel.tune(withText:       "View Pictures Title".localized(),
                                                        hexColors:      veryDarkGrayWhiteColorPickers,
                                                        font:           UIFont(name: "SFProDisplay-Regular", size: 14.0),
                                                        alignment:      .left,
                                                        isMultiLines:   false)
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
    
    @IBOutlet var grayViewsCollection: [UIView]! {
        didSet {
            self.grayViewsCollection.forEach({ $0.theme_backgroundColor = lightGrayishBlueBlackColorPickers })
        }
    }
    
    @IBOutlet var lineViewsCollection: [UIView]! {
        didSet {
            self.lineViewsCollection.forEach({ $0.theme_backgroundColor = veryLightGrayVeryDarkGrayColorPickers })
        }
    }
    
    @IBOutlet var arrowImageViewsCollection: [UIImageView]! {
        didSet {
            self.arrowImageViewsCollection.forEach({ $0.theme_image = [ "icon-button-arrow-rigth-gray-day-normal", "icon-button-arrow-rigth-gray-dark-normal" ]})
        }
    }

    @IBOutlet var constraintsCollection: [NSLayoutConstraint]! {
        didSet {
            self.constraintsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
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
        
        // Microservice API `getOptions`
        self.getOptions(type: .basic, completion: { [weak self] success in
            guard let strongSelf = self else { return }

            strongSelf.localizeTitles()
            strongSelf.loadViewSettings()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set StatusBarStyle
        selectedTabBarItem          =   self.navigationController!.tabBarItem.tag
        self.isStatusBarStyleLight  =   AppSettings.isAppThemeDark

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
        self.showNavigationBar()
        
//        let requestModel    =   SettingsShowModels.Items.RequestModel()
//        interactor?.doSomething(withRequestModel: requestModel)
    }
    
    
    // MARK: - Actions
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        let actionSheet     =   UIAlertController(title: nil, message: "Interface Language".localized(), preferredStyle: .actionSheet)
        
        for language in Localize.availableLanguages().filter({ $0 != "Base" }) {
            let displayName     =   Localize.displayNameForLanguage(language).uppercaseFirst
            
            let languageAction  =   UIAlertAction(title: displayName, style: .default, handler: { _ in
                Localize.setCurrentLanguage(language)
                self.languageLabel.text = "Language App".localized()
            })
            
            actionSheet.addAction(languageAction)
        }
        
        let cancelAction = UIAlertAction(title: "ActionCancel".localized(), style: .cancel, handler: { _ in })
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func currencyButtonTapped(_ sender: Any) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func voicePowerButtonTapped(_ sender: Any) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func wikiGolosButtonTapped(_ sender: Any) {
        self.openExternalLink(byURL: GolosWebPage.wiki.rawValue)
    }
    
    @IBAction func welcomeButtonTapped(_ sender: Any) {
        self.openExternalLink(byURL: GolosWebPage.welcome.rawValue)
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        self.openExternalLink(byURL: GolosWebPage.privacyPolicy.rawValue)
    }
    
    @IBAction func switchAccountButtonTapped(_ sender: Any) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        guard self.isCurrentOperationPossible() else { return }

        self.showAlertView(withTitle: "Exit", andMessage: "Are Your Sure?", actionTitle: "ActionYes", needCancel: true, completion: { [weak self] success in
            if success {
                self?.router?.routeToLoginShowScene()
                
                // Amplitude SDK
                Amplitude.instance()?.setUserId(nil)
                Amplitude.instance()?.regenerateDeviceId()
            }
        })
    }
    
    @IBAction func editUserProfileButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
//        self.router?.routeToSettingsUserProfileEditScene()
    }

    @IBAction func pushNotificationsButtonTapped(_ sender: UIButton) {
        self.router?.routeToSettingsPushNotificationsScene()
    }

    @IBAction func dayRadioButtonTapped(_ sender: DLRadioButton) {
        AppSettings.instance().setAppThemeDark(false)
        
        self.isStatusBarStyleLight      =   false
        self.dayImageView.image         =   UIImage(named: "icon-button-day-selected")
        self.dayRadioButton.iconColor   =   UIColor(hexString: "#2F7DFB")
        self.moonImageView.image        =   UIImage(named: "icon-button-moon-normal")
        self.moonRadioButton.iconColor  =   UIColor(hexString: "#B7B7BA")
        
        self.navigationController?.navigationBar.layer.theme_shadowColor  =   veryLightGrayCGColorPickers
        (self.tabBarController as! GSTabBarController).setup()
        
        // Microservice API `setOptions`
        self.setBasicOptions()
    }

    @IBAction func moonRadioButtonTapped(_ sender: Any) {
        AppSettings.instance().setAppThemeDark(true)

        self.isStatusBarStyleLight      =   true
        self.dayImageView.image         =   UIImage(named: "icon-button-day-normal")
        self.dayRadioButton.iconColor   =   UIColor(hexString: "#B7B7BA")
        self.moonImageView.image        =   UIImage(named: "icon-button-moon-selected")
        self.moonRadioButton.iconColor  =   UIColor(hexString: "#2F7DFB")
        self.navigationController?.navigationBar.layer.theme_shadowColor  =   whiteVeryDarkGrayCGColorPickers
        (self.tabBarController as! GSTabBarController).setup()
        
        // Microservice API `setOptions`
        self.setBasicOptions()
    }
    
    @IBAction func viewPicturesSwitchChanged(_ sender: UISwitch) {
        AppSettings.instance().setFeedShowImages(sender.isOn)
        
        // Microservice API `setOptions`
        self.setBasicOptions()
    }
    
    /// Set titles with support App language
    @objc override func localizeTitles() {
        self.title                                      =   "Settings".localized()
        self.commonLabel.text                           =   "COMMON".localized()
        self.versionLabel.text                          =   String(format: "Golos %@ iOS %@", "for".localized(), appVersion)
        self.languageLabel.text                         =   "Language App".localized()
        self.displayModeTitleLabel.text                 =   "Display Mode Title".localized()
        self.displayModeViewPicturesTitleLabel.text     =   "View Pictures Title".localized()
        
        self.wikiGolosButton.setTitle("Wiki Golos".localized(), for: .normal)
        self.welcomeButton.setTitle("About Golos.io".localized(), for: .normal)
        self.voicePowerButton.setTitle("Voice Power".localized(), for: .normal)
        self.currencyButton.setTitle("Select Currency".localized(), for: .normal)
        self.languageButton.setTitle("Interface Language".localized(), for: .normal)
        self.privacyPolicyButton.setTitle("Privacy Policy".localized(), for: .normal)
        self.switchAccountButton.setTitle("Switch Account Verb".localized(), for: .normal)
        self.editUserProfileButton.setTitle("Edit Profile Title".localized(), for: .normal)
        self.pushNotificationsButton.setTitle("Settings Push Notifications".localized(), for: .normal)
        self.logOutButton.setTitle((User.isAnonymous ? "Log In" : "Exit Verb").localized(), for: .normal)
        
        self.radioButtonsCollection.forEach({ $0.setTitle($0.accessibilityIdentifier?.localized(), for: .normal) })
    }
}


// MARK: - SettingsShowDisplayLogic
extension SettingsShowViewController: SettingsShowDisplayLogic {
    func displaySomething(fromViewModel viewModel: SettingsShowModels.Items.ViewModel) {
        // NOTE: Display the result from the Presenter
    }
}


// MARK: - Microservices
extension SettingsShowViewController {
    private func setBasicOptions() {
        MicroservicesManager.setBasicOptions(userNickName: currentUserNickName!, deviceUDID: currentDeviceUDID, isDarkTheme: AppSettings.instance().isAppThemeDark, isFeedShowImages: AppSettings.instance().isFeedShowImages, completion: { [weak self] errorAPI in
            guard let strongSelf = self else { return }
            
            if errorAPI != nil {
                strongSelf.showAlertView(withTitle: "Error", andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
            }
        })
    }
    
    private func getOptions(type: MicroserviceOperationsType, completion: @escaping (Bool) -> Void) {
        MicroservicesManager.getOptions(type: type, userNickName: currentUserNickName!, deviceUDID: currentDeviceUDID, completion: { [weak self] (resultOptions, errorAPI) in
            guard let strongSelf = self else { return }
            
            if errorAPI != nil {
                strongSelf.showAlertView(withTitle: "Error", andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in
                    completion(false)
                })
            }
            
            // Synchronize 'basic' options
            else if let optionsResult = resultOptions?.result {
                Logger.log(message: "push = \n\t\(optionsResult.push)", event: .debug)
                Logger.log(message: "basic = \n\t\(optionsResult.basic)", event: .debug)
                Logger.log(message: "notify = \n\t\(optionsResult.notify)", event: .debug)
                
                // CoreData: modify AppSettings
                AppSettings.instance().update(basic: optionsResult.basic)
                completion(true)
            }
        })
    }
}
