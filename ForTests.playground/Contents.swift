import UIKit
import GoloSwift
import CoreFoundation

//class ParkBenchTimer {
//    // MARK: - Properties
//    let startTime: CFAbsoluteTime
//    let operationName: String
//    var endTime: CFAbsoluteTime?
//    let showNanoSec: Bool
//
//
//    // MARK: - Class Initialization
//    init(operationName: String = "Test operation", showNanoSec: Bool = true) {
//        self.startTime      =   CFAbsoluteTimeGetCurrent()
//        self.operationName  =   operationName
//        self.showNanoSec    =   showNanoSec
//    }
//
//    deinit {
//        Logger.log(message: "Success", event: .severe)
//    }
//
//
//    // MARK: - Class Functions
////    func stop() {
////        let endTime = CFAbsoluteTimeGetCurrent()
////
////        Logger.log(message: "The operation \(self.operationName) took \(endTime) seconds", event: .verbose)
////    }
//
//    func stop() {
//        endTime = CFAbsoluteTimeGetCurrent()
//
//        DispatchQueue.main.async {
//        print("The task \"\(timer.operationName)\" took \(self.duration) seconds.")
//        }
//
////        return duration!
//    }
//
//    private var duration: Float {
//        if let endTime = endTime {
//            return Float(endTime - startTime) / (self.showNanoSec ? 1 : 1_000_000_000.0)
//        } else {
//            return 0
//        }
//    }
//}
//
////let timer = ParkBenchTimer()
////
////for i in 0...2_000 {
////    print(i)
////}


//func printExecutionTime(withTag tag: String, of closure: () -> ()) {
//    let start = CACurrentMediaTime()
//    closure()
//    Logger.log(message: "#\(tag) - execution took \(CACurrentMediaTime() - start) seconds", event: .verbose)
//}
//
//printExecutionTime(withTag: "Test operaion") {
//    for i in 0...2_000 {
//        print(i)
//    }
//}
