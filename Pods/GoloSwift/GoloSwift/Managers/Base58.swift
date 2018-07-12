//
//  Base58.swift
//  NeoSwift
//
//  Created by Luís Silva on 11/09/17.
//  Copyright © 2017 drei. All rights reserved.
//
//  https://github.com/CityOfZion/neo-swift/blob/master/NeoSwift/Util/Base58.swift

import Foundation

public struct Base58 {
    static let base58Alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    
    /// Encode
    static func base58FromBytes(_ bytes: [Byte]) -> String {
        var bytes = bytes
        var zerosCount = 0
        var length = 0
        
        for b in bytes {
            if b != 0 { break }
            zerosCount += 1
        }
        
        bytes.removeFirst(zerosCount)
        
        let size = bytes.count * 138 / 100 + 1
        var base58: [Byte] = Array(repeating: 0, count: size)
        
        for b in bytes {
            var carry = Int(b)
            var i = 0
            
            for j in 0...base58.count-1 where carry != 0 || i < length {
                carry += 256 * Int(base58[base58.count - j - 1])
                base58[base58.count - j - 1] = Byte(carry % 58)
                carry /= 58
                i += 1
            }
            
            assert(carry == 0)
            
            length = i
        }
        
        // Skip leading zeros
        var zerosToRemove = 0
        var str = ""
        
        for b in base58 {
            if b != 0 { break }
            zerosToRemove += 1
        }
        
        base58.removeFirst(zerosToRemove)
        
        while 0 < zerosCount {
            str = "\(str)1"
            zerosCount -= 1
        }
        
        for b in base58 {
            str = "\(str)\(base58Alphabet[String.Index(encodedOffset: Int(b))])"
        }
        
        return str
    }
    
    /// Decode
    static func bytesFromBase58(_ base58: String) -> [Byte] {
        // Remove leading and trailing whitespaces
        let string = base58.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard !string.isEmpty else { return [] }
        
        var zerosCount = 0
        var length = 0
        
        for c in string {
            if c != "1" { break }
            zerosCount += 1
        }
        
        let size = string.lengthOfBytes(using: String.Encoding.utf8) * 733 / 1000 + 1 - zerosCount
        var base58: [Byte] = Array(repeating: 0, count: size)
        
        for c in string where c != " " {
            // search for base58 character
            guard let base58Index = base58Alphabet.index(of: c) else { return [] }
            
            var carry = base58Index.encodedOffset
            var i = 0
            
            for j in 0...base58.count where carry != 0 || i < length {
                carry += 58 * Int(base58[base58.count - j - 1])
                base58[base58.count - j - 1] = Byte(carry % 256)
                carry /= 256
                i += 1
            }
            
            assert(carry == 0)
            length = i
        }
        
        // Skip leading zeros
        var zerosToRemove = 0
        
        for b in base58 {
            if b != 0 { break }
            zerosToRemove += 1
        }
        
        base58.removeFirst(zerosToRemove)
        
        var result: [Byte] = Array(repeating: 0, count: zerosCount)
        for b in base58 {
            result.append(b)
        }
        
        return result
    }
    
    
    /// Convert `Posting key` from String to [Byte]
    public func base58Decode(data: String) -> [Byte] {
        Logger.log(message: "\ntx - postingKeyString:\n\t\(data)\n", event: .debug)
        let s: [Byte] = Base58.bytesFromBase58(data)
        let dec = cutLastBytes(source: s, cutCount: 4)
        
        Logger.log(message: "\ntx - postingKeyData:\n\t\(dec.toHexString())\n", event: .debug)
        return cutFirstBytes(source: dec, cutCount: 1)
    }
    
    /// Service function
    func cutLastBytes(source: [Byte], cutCount: Int) -> [Byte] {
        var result = source
        result.removeSubrange((source.count - cutCount)..<source.count)
        
        return result
    }
    
    /// Service function
    func cutFirstBytes(source: [Byte], cutCount: Int) -> [Byte] {
        var result = source
        result.removeSubrange(0..<cutCount)
        
        return result
    }
}
