//
//  PostCreateInteractor.swift
//  golos-ios
//
//  Created by msm72 on 11.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Business Logic protocols
protocol PostCreateBusinessLogic {
    func doSomething(withRequestModel requestModel: PostCreateModels.Something.RequestModel)
}

protocol PostCreateDataStore {
     var commentText: String { get set }
}

class PostCreateInteractor: PostCreateBusinessLogic, PostCreateDataStore {
    // MARK: - Properties
    var presenter: PostCreatePresentationLogic?
    var worker: PostCreateWorker?
    
    // PostCreateDataStore protocol implementation
    var commentText: String = ""
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func doSomething(withRequestModel requestModel: PostCreateModels.Something.RequestModel) {
        worker = PostCreateWorker()
        worker?.doSomeWork()
        
        let responseModel = PostCreateModels.Something.ResponseModel()
        presenter?.presentSomething(fromResponseModel: responseModel)
    }
}
