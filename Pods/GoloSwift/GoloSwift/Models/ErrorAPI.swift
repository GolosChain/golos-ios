//
//  ErrorAPI.swift
//  GoloSwift
//
//  Created by msm72 on 17.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation
import Localize_Swift

public enum ErrorAPI: Error {
    case invalidData(message: String)
    case requestFailed(message: String)
    case jsonParsingFailure(message: String)
    case responseUnsuccessful(message: String)
    case jsonConversionFailure(message: String)
    case signingECCKeychainPostingKeyFailure(message: String)

    public var caseInfo: (title: String, message: String) {
        switch self {
        case .invalidData(let message):
            return (title: "Invalid Data".localized(), message: message)
            
        case .requestFailed(let message):
            return (title: "Request Failed".localized(), message: message)
            
        case .responseUnsuccessful(let message):
            return (title: "Response Unsuccessful".localized(), message: message)
            
        case .jsonParsingFailure(let message):
            return (title: "JSON Parsing Failure".localized(), message: message)
            
        case .jsonConversionFailure(let message):
            return (title: "JSON Conversion Failure".localized(), message: message)
            
        case .signingECCKeychainPostingKeyFailure(let message):
            return (title: "Keychain Posting Key Failure".localized(), message: message)
        }
    }
}
