//
//  Array+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 10.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

extension Array {
    static func add(randomElementsCount count: Int) -> [Byte] {
        return (0..<count).map{ _ in Byte(arc4random_uniform(UInt32(Byte.max))) }
    }

    var string: String {
        let data = Data(bytes: self as! [Byte], count: self.count)
        
        return String(data: data, encoding: .utf8)!
    }
}


extension Array where Element == Byte {
    public var base58EncodedString: String {
        guard !self.isEmpty else { return "" }
        return Base58.base58FromBytes(self)
    }
}
