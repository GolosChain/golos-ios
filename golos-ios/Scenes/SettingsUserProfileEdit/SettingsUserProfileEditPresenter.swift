//
//  SettingsUserProfileEditPresenter.swift
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

// MARK: - Presentation Logic protocols
protocol SettingsUserProfileEditPresentationLogic {
    func presentSomething(fromResponseModel responseModel: SettingsUserProfileEditModels.Profile.ResponseModel)
}

class SettingsUserProfileEditPresenter: SettingsUserProfileEditPresentationLogic {
    // MARK: - Properties
    weak var viewController: SettingsUserProfileEditDisplayLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Presentation Logic implementation
    func presentSomething(fromResponseModel responseModel: SettingsUserProfileEditModels.Profile.ResponseModel) {
        let viewModel = SettingsUserProfileEditModels.Profile.ViewModel()
        viewController?.displaySomething(fromViewModel: viewModel)
    }
}
