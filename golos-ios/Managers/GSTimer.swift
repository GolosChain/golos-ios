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
    var operationTimer: Timer?
    
    
    // MARK: - Class Initialization
    init(operationName: String = "Test operation", time: Double = 0.0, completion: @escaping (Bool) -> Void) {
        self.startTime      =   CFAbsoluteTimeGetCurrent()
        self.operationName  =   operationName
        
        if time != 0.0 {
            if #available(iOS 10.0, *) {
                self.operationTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in
                    completion(true)
                })
            }
            
            else {
                // Fallback on earlier versions
            }
        }
        
        else {
            completion(false)
        }
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Custom Functions
    func stop() {
        self.endTime = CFAbsoluteTimeGetCurrent()
        self.operationTimer?.invalidate()
        
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
