//
//  ReusableCell.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

protocol HandlersCellSupport {
    var handlerShareButtonTapped: (() -> Void)? { get set }
    var handlerUpvotesButtonTapped: (() -> Void)? { get set }
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)? { get set }
}


// MARK: - Default implementation of ReusableCell protocol
extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
