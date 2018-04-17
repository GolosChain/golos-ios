//
//  ErrorAPI.swift
//  Golos
//
//  Created by msm72 on 17.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Localize_Swift

enum ErrorAPI: Error {
    case requestFailed(message: String)
    case jsonConversionFailure(message: String)
    case invalidData(message: String)
    case responseUnsuccessful(message: String)
    case jsonParsingFailure(message: String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed(let message):
            return "Request Failed".localized() + ": \(message)"
        
        case .invalidData(let message):
            return "Invalid Data".localized() + ": \(message)"
        
        case .responseUnsuccessful(let message):
            return "Response Unsuccessful".localized() + ": \(message)"
        
        case .jsonParsingFailure(let message):
            return "JSON Parsing Failure".localized() + ": \(message)"
        
        case .jsonConversionFailure(let message):
            return "JSON Conversion Failure".localized() + ": \(message)"
        }
    }
}
