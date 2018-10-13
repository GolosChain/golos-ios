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
    func presentLoadPostContent(fromResponseModel responseModel: PostShowModels.Post.ResponseModel)
    func presentLoadPostComments(fromResponseModel responseModel: PostShowModels.Post.ResponseModel)
    func presentCheckFollowing(fromResponseModel responseModel: PostShowModels.Following.ResponseModel)
    func presentVote(fromResponseModel responseModel: PostShowModels.ActiveVote.ResponseModel)
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
    
    func presentLoadPostContent(fromResponseModel responseModel: PostShowModels.Post.ResponseModel) {
        let viewModel = PostShowModels.Post.ViewModel(errorAPI: responseModel.errorAPI)
        viewController?.displayLoadPostContent(fromViewModel: viewModel)
    }

    func presentLoadPostComments(fromResponseModel responseModel: PostShowModels.Post.ResponseModel) {
        let viewModel = PostShowModels.Post.ViewModel(errorAPI: responseModel.errorAPI)
        viewController?.displayLoadPostComments(fromViewModel: viewModel)
    }
    
    func presentCheckFollowing(fromResponseModel responseModel: PostShowModels.Following.ResponseModel) {
        let viewModel = PostShowModels.Following.ViewModel(isFollowing: responseModel.isFollowing, errorAPI: responseModel.errorAPI)
        viewController?.displayCheckFollowing(fromViewModel: viewModel)
    }
    
    func presentVote(fromResponseModel responseModel: PostShowModels.ActiveVote.ResponseModel) {
        let viewModel = PostShowModels.ActiveVote.ViewModel(isVote: responseModel.isVote, isFlaunt: responseModel.isFlaunt, forPost: responseModel.forPost, errorAPI: responseModel.errorAPI)
        viewController?.displayVote(fromViewModel: viewModel)
    }
}
