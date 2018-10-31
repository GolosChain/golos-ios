//
//  UserFollowersShowPresenter.swift
//  golos-ios
//
//  Created by msm72 on 10/29/18.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Presentation Logic protocols
protocol UserFollowersShowPresentationLogic {
    func presentSubscribe(fromResponseModel responseModel: UserFollowersShowModels.Sub.ResponseModel)
    func presentLoadFollowers(fromResponseModel responseModel: UserFollowersShowModels.Item.ResponseModel)
    func presentLoadFollowings(fromResponseModel responseModel: UserFollowersShowModels.Item.ResponseModel)
}

class UserFollowersShowPresenter: UserFollowersShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: UserFollowersShowDisplayLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Presentation Logic implementation
    func presentSubscribe(fromResponseModel responseModel: UserFollowersShowModels.Sub.ResponseModel) {
        let viewModel = UserFollowersShowModels.Sub.ViewModel(isFollowing: responseModel.isFollowing, authorNickName: responseModel.authorNickName, errorAPI: responseModel.errorAPI)
        viewController?.displaySubscribe(fromViewModel: viewModel)
    }

    func presentLoadFollowers(fromResponseModel responseModel: UserFollowersShowModels.Item.ResponseModel) {
        let viewModel = UserFollowersShowModels.Item.ViewModel(errorAPI: responseModel.errorAPI)
        viewController?.displayLoadFollowers(fromViewModel: viewModel)
    }

    func presentLoadFollowings(fromResponseModel responseModel: UserFollowersShowModels.Item.ResponseModel) {
        let viewModel = UserFollowersShowModels.Item.ViewModel(errorAPI: responseModel.errorAPI)
        viewController?.displayLoadFollowings(fromViewModel: viewModel)
    }
}
