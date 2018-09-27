//
//  PostShowPresenter.swift
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

// MARK: - Presentation Logic protocols
protocol PostShowPresentationLogic {
    func presentSubscribe(fromResponseModel responseModel: PostShowModels.Item.ResponseModel)
    func presentLoadContent(fromResponseModel responseModel: PostShowModels.Post.ResponseModel)
    func presentLoadContentComments(fromResponseModel responseModel: PostShowModels.Post.ResponseModel)
    func presentCheckFollowing(fromResponseModel responseModel: PostShowModels.Following.ResponseModel)
}

class PostShowPresenter: PostShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: PostShowDisplayLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Presentation Logic implementation
    func presentSubscribe(fromResponseModel responseModel: PostShowModels.Item.ResponseModel) {
        let viewModel = PostShowModels.Item.ViewModel(isFollowing: responseModel.isFollowing, errorAPI: responseModel.errorAPI)
        viewController?.displaySubscribe(fromViewModel: viewModel)
    }
    
    func presentLoadContent(fromResponseModel responseModel: PostShowModels.Post.ResponseModel) {
        let viewModel = PostShowModels.Post.ViewModel(errorAPI: responseModel.errorAPI)
        viewController?.displayLoadContent(fromViewModel: viewModel)
    }

    func presentLoadContentComments(fromResponseModel responseModel: PostShowModels.Post.ResponseModel) {
        let viewModel = PostShowModels.Post.ViewModel(errorAPI: responseModel.errorAPI)
        viewController?.displayLoadContentComments(fromViewModel: viewModel)
    }
    
    func presentCheckFollowing(fromResponseModel responseModel: PostShowModels.Following.ResponseModel) {
        let viewModel = PostShowModels.Following.ViewModel(isFollowing: responseModel.isFollowing, errorAPI: responseModel.errorAPI)
        viewController?.displayCheckFollowing(fromViewModel: viewModel)
    }
}
