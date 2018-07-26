//
//  SettingsUserProfileEditViewController.swift
//  golos-ios
//
//  Created by msm72 on 25.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift
import SwiftTheme

// MARK: - Input & Output protocols
protocol SettingsUserProfileEditDisplayLogic: class {
    func displaySomething(fromViewModel viewModel: SettingsUserProfileEditModels.Profile.ViewModel)
}

class SettingsUserProfileEditViewController: GSBaseViewController {
    // MARK: - Properties
    var interactor: SettingsUserProfileEditBusinessLogic?
    var router: (NSObjectProtocol & SettingsUserProfileEditRoutingLogic & SettingsUserProfileEditDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topLineView: UIView! {
        didSet {
            topLineView.tune(withThemeColorPicker: lightGrayishBlueWhiteColorPickers)
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.tune(withThemeColorPicker: whiteBlackColorPickers)
        }
    }

    @IBOutlet weak var userAvatarImageView: UIImageView! {
        didSet {
            userAvatarImageView.layer.cornerRadius = userAvatarImageView.bounds.size.width / 2 * widthRatio
        }
    }
    
    @IBOutlet weak var changeAvatarButton: UIButton! {
        didSet {
            changeAvatarButton.tune(withTitle:       "Other photo Title".localized(),
                                    hexColors:       vividBlueWhiteColorPickers,
                                    font:            UIFont(name: "SFProDisplay-Regular", size: 12.0 * widthRatio),
                                    alignment:      .center)
        }
    }
    
    @IBOutlet weak var changeCoverButton: UIButton! {
        didSet {
            changeCoverButton.tune(withTitle:       "Change User Cover Photo Title".localized(),
                                   hexColors:       darkGrayWhiteColorPickers,
                                   font:            UIFont(name: "SFProDisplay-Regular", size: 14.0 * widthRatio),
                                   alignment:       .center)
            
            changeCoverButton.layer.cornerRadius        =   4.0 * heightRatio
            changeCoverButton.layer.borderWidth         =   1.0 * heightRatio
            changeCoverButton.layer.borderColor         =   UIColor(hexString: "#dbdbdb").cgColor
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.tune(withTitle:       "Save Verb Title".localized(),
                            hexColors:       whiteColorPickers,
                            font:            UIFont(name: "SFProDisplay-Regular", size: 16.0 * widthRatio),
                            alignment:       .center)

            saveButton.layer.cornerRadius        =   4.0 * heightRatio
            saveButton.theme_backgroundColor     =   vividBlueColorPickers
        }
    }
    
    @IBOutlet var viewsCollection: [UIView]! {
        didSet {
            _ = viewsCollection.map({ $0.theme_backgroundColor = whiteBlackColorPickers })
        }
    }
    
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
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
        let interactor              =   SettingsUserProfileEditInteractor()
        let presenter               =   SettingsUserProfileEditPresenter()
        let router                  =   SettingsUserProfileEditRouter()
        
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
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.title          =   "Edit Profile Title".localized()
        
//        let requestModel    =   SettingsUserProfileEditModels.Profile.RequestModel()
//        interactor?.doSomething(withRequestModel: requestModel)
    }
    
    
    // MARK: - Actions
    @IBAction func changeCoverButtonTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func changeAvatarButtonTapped(_ sender: UIButton) {
    
    }
}


// MARK: - SettingsUserProfileEditDisplayLogic
extension SettingsUserProfileEditViewController: SettingsUserProfileEditDisplayLogic {
    func displaySomething(fromViewModel viewModel: SettingsUserProfileEditModels.Profile.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
}
