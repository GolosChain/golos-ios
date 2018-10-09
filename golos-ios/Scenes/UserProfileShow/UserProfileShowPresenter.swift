//
//  UserProfileShowPresenter.swift
//  golos-ios
//
//  Created by msm72 on 29.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Presentation Logic protocols
protocol UserProfileShowPresentationLogic {
    func presentUserInfo(fromResponseModel responseModel: UserProfileShowModels.UserInfo.ResponseModel)
    func presentUserDetails(fromResponseModel responseModel: UserProfileShowModels.UserDetails.ResponseModel)
    func presentUpvote(fromResponseModel responseModel: UserProfileShowModels.ActiveVote.ResponseModel)
}

class UserProfileShowPresenter: UserProfileShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: UserProfileShowDisplayLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Presentation Logic implementation
    func presentUserInfo(fromResponseModel responseModel: UserProfileShowModels.UserInfo.ResponseModel) {
        let userInfoViewModel = UserProfileShowModels.UserInfo.ViewModel(error: responseModel.error)
        viewController?.displayUserInfo(fromViewModel: userInfoViewModel)
    }
    
    func presentUserDetails(fromResponseModel responseModel: UserProfileShowModels.UserDetails.ResponseModel) {
        let userDetailsViewModel = UserProfileShowModels.UserDetails.ViewModel(error: responseModel.error)
        viewController?.displayUserDetails(fromViewModel: userDetailsViewModel)
    }
    
    func presentUpvote(fromResponseModel responseModel: UserProfileShowModels.ActiveVote.ResponseModel) {
        let viewModel = UserProfileShowModels.ActiveVote.ViewModel(isUpvote: responseModel.isUpvote, errorAPI: responseModel.errorAPI)
        viewController?.displayUpvote(fromViewModel: viewModel)
    }
}
