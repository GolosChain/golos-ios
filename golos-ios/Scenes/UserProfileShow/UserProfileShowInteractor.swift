//
//  UserProfileShowInteractor.swift
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

// MARK: - Business Logic protocols
protocol UserProfileShowBusinessLogic {
    func doSomething(withRequestModel requestModel: UserProfileShowModels.Something.RequestModel)
}

protocol UserProfileShowDataStore {
//     var name: String { get set }
}

class UserProfileShowInteractor: UserProfileShowBusinessLogic, UserProfileShowDataStore {
    // MARK: - Properties
    var presenter: UserProfileShowPresentationLogic?
    var worker: UserProfileShowWorker?
    
    // ... protocol implementation
//    var name: String = ""
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func doSomething(withRequestModel requestModel: UserProfileShowModels.Something.RequestModel) {
        worker = UserProfileShowWorker()
        worker?.doSomeWork()
        
        let responseModel = UserProfileShowModels.Something.ResponseModel()
        presenter?.presentSomething(fromResponseModel: responseModel)
    }
}
