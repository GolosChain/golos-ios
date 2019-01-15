//
//  SettingsNotificationsShowInteractor.swift
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
import Localize_Swift

// MARK: - Business Logic protocols
protocol SettingsNotificationsShowBusinessLogic {
    func loadPushNotificationsOptions(withRequestModel requestModel: SettingsNotificationsShowModels.Options.RequestModel)
    func setAllPushNotificationsShowOptions(withRequestModel requestModel: SettingsNotificationsShowModels.Options.RequestModel)
}

protocol SettingsNotificationsShowDataStore {
//     var name: String { get set }
}

class SettingsNotificationsShowInteractor: SettingsNotificationsShowBusinessLogic, SettingsNotificationsShowDataStore {
    // MARK: - Properties
    var presenter: SettingsNotificationsShowPresentationLogic?
    
    // ... protocol implementation
//    var name: String = ""
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func loadPushNotificationsOptions(withRequestModel requestModel: SettingsNotificationsShowModels.Options.RequestModel) {
        // API push `getOptions`
        MicroservicesManager.getOptions(type: .push, userNickName: currentUserNickName!, deviceUDID: currentDeviceUDID, completion: { [weak self] (resultOptions, errorAPI) in
            guard let strongSelf = self else { return }
            
            // Synchronize 'basic' options
            if let optionsResult = resultOptions?.result {
                Logger.log(message: "push = \n\t\(optionsResult.push)", event: .debug)
                Logger.log(message: "basic = \n\t\(optionsResult.basic)", event: .debug)
                Logger.log(message: "notify = \n\t\(optionsResult.notify)", event: .debug)
                
                // CoreData: modify AppSettings
                AppSettings.instance().update(push: optionsResult.push)
            }
            
            let responseModel = SettingsNotificationsShowModels.Options.ResponseModel(errorAPI: errorAPI)
            strongSelf.presenter?.presentLoadPushNotificationsOptions(fromResponseModel: responseModel)
        })
    }
    
    func setAllPushNotificationsShowOptions(withRequestModel requestModel: SettingsNotificationsShowModels.Options.RequestModel) {
        // API all push `setOptions`
        MicroservicesManager.setPushOptions(userNickName: currentUserNickName!, deviceUDID: currentDeviceUDID, options: RequestParameterAPI.PushOptions.init(languageValue: Localize.currentLanguage(), valueForAll: requestModel.isShowAllNotificationsOptions ?? true), completion: { [weak self] errorAPI in
            guard let strongSelf = self else { return }
            
            // Synchronize `all push` options
            if errorAPI == nil {
                // CoreData: modify AppSettings
                AppSettings.instance().updateAllPushNotifications(value: requestModel.isShowAllNotificationsOptions ?? true)
            }
            
            let responseModel = SettingsNotificationsShowModels.Options.ResponseModel(errorAPI: errorAPI)
            strongSelf.presenter?.presentSetAllPushNotificationsShowOptions(fromResponseModel: responseModel)
        })
    }
}
