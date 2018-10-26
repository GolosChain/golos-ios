//
//  ActiveVotersShowModels.swift
//  golos-ios
//
//  Created by msm72 on 10/25/18.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Data models
enum ActiveVotersShowModels {
    // MARK: - Use cases
    enum Sub {
        struct RequestModel {
            let willSubscribe: Bool
            let authorNickName: String
        }
        
        struct ResponseModel {
            let isFollowing: Bool
            let authorNickName: String
            let errorAPI: ErrorAPI?
        }
        
        struct ViewModel {
            let isFollowing: Bool
            let authorNickName: String
            let errorAPI: ErrorAPI?
        }
    }

    enum Item {
        struct RequestModel {
        }
        
        struct ResponseModel {
            let errorAPI: ErrorAPI?
        }
        
        struct ViewModel {
            let errorAPI: ErrorAPI?
        }
    }
}
