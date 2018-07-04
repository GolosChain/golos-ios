//
//  UserProfileShowModels.swift
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
import CoreData

// MARK: - Data models
enum UserProfileShowModels {
    // MARK: - Use cases
    enum UserInfo {
        struct RequestModel {
        }
        
        struct ResponseModel {
            let user: User?
            let error: ErrorAPI?
        }
        
        struct ViewModel {
        }
    }

    enum UserDetails {
        struct RequestModel {
        }
        
        struct ResponseModel {
//            let user: User?
            let error: ErrorAPI?
        }
        
        struct ViewModel {
        }
    }
}
