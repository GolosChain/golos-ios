//
//  GSTimer.swift
//  Golos
//
//  Created by msm72 on 10/13/18.
//  Copyright © 2018 golos. All rights reserved.
//

import GoloSwift
import CoreFoundation

class GSTimer {
    // MARK: - Properties
    var endTime: CFAbsoluteTime?
    let startTime: CFAbsoluteTime
    let operationName: String

    
    // MARK: - Class Initialization
    init(operationName: String = "Test operation") {
        self.startTime      =   CFAbsoluteTimeGetCurrent()
        self.operationName  =   operationName
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Custom Functions
    func stop() {
        endTime = CFAbsoluteTimeGetCurrent()
        
        Logger.log(message: "The operation \(self.operationName) took \(duration) seconds", event: .verbose)
    }
    
    private var duration: CFAbsoluteTime {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return 0
        }
    }
}
