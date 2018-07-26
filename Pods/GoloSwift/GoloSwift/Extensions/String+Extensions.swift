//
//  String+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

extension String {
    public func convert(toDateFormat dateFormatType: DateFormatType) -> Date {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   dateFormatType.rawValue
        dateFormatter.timeZone      =   TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: self)!
    }
    
    func convert(toIntFromStartByte startIndex: Int, toEndByte endIndex: Int) -> UInt32 {
        // Test value "00ce18271e38c48379c4744702be5202d42b2d23"
        let selfString: [Character]         =   Array(self)
        let selfStringBytesArray: [UInt8]   =   stride(from: 0, to: count, by: 2).compactMap { UInt8(String(selfString[$0..<$0.advanced(by: 2)]), radix: 16) }.reversed()
        let selectedBytesArray: [UInt8]     =   Array(selfStringBytesArray[startIndex..<endIndex])
        let selectedBytesArrayData: Data    =   Data(bytes: selectedBytesArray)
        
        return UInt32(bigEndian: selectedBytesArrayData.withUnsafeBytes { $0.pointee })
    }
    
    public var hexBytes: [Byte] {
        return stride(from: 0, to: count, by: 2).compactMap { Byte(String(Array(self)[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
    
    
    /// Base58 decode
    public var base58EncodedString: String {
        return [Byte](utf8).base58EncodedString
    }
    
    
    /// Cyrillic
    var isBothLatinAndCyrillic: Bool {
        return self.isLatin && self.isCyrillic
    }
    
    var isLatin: Bool {
        let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lower = "abcdefghijklmnopqrstuvwxyz"
        
        for char in self.map({ String($0) }) {
            if !upper.contains(char) && !lower.contains(char) {
                return false
            }
        }
        
        return true
    }
    
    var isCyrillic: Bool {
        let upper = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯ"
        let lower = "абвгдежзийклмнопрстуфхцчшщьюя"
        
        for char in self.map({ String($0) }) {
            if !upper.contains(char) && !lower.contains(char) {
                return false
            }
        }
        
        return true
    }
    
    /// Cyrillic -> Latin
    func transliterationInLatin() -> String {
        guard self.isCyrillic else {
            return self
        }
        
        var newString: String = ""
        var latinChar: String
        
        for char in self {
            latinChar = transliterate(char: "\(char)")
            newString.append(latinChar)
        }
        
        return String(format: "ru--%@", newString)
    }
    
    func transliterate(char: String) -> String {
        let cyrillicChars   =   [ "щ", "ш", "ч", "ц", "й", "ё", "э", "ю", "я", "х", "ж", "а", "б", "в", "г", "д", "е", "з", "и", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "ъ", "ы", "ь", "ґ", "є", "і", "ї" ]
        
        // https://github.com/GolosChain/tolstoy/blob/master/app/utils/ParsersAndFormatters.js#L117
        let latinChars      =   [ "shch", "sh", "ch", "cz", "ij", "yo", "ye", "yu", "ya", "kh", "zh", "a", "b", "v", "g", "d", "e", "z", "i", "k", "l", "m", "n", "o", "p", "r", "s",               "t", "u", "f", "xx", "y", "x", "g", "e", "i", "i" ]
        
        let convertDict     =   NSDictionary.init(objects: latinChars, forKeys: cyrillicChars as [NSCopying])
        
        return convertDict.value(forKey: char.lowercased()) as! String
    }
    
    
    /// Convert 'reputation' -> Int
    public func convertWithLogarithm10() -> Int {
        if self == "0" {
            return 0
        }
        
        let isNegative      =   self.hasPrefix("-")
        let reputationNew   =   isNegative ? String(self[self.index(self.startIndex, offsetBy: 1)...]) : self
        var result          =   log10(reputationNew)
        
        if result.isNaN {
            return 0
        }
        
        // @ -9, $0.50 earned is approx magnitude 1
        result      =   max(result - 9, 0)
        result      *=  (isNegative ? -1 : 1)
        
        // 9 points per magnitude. center at 25
        result      =   result * 9 + 25
        
        // base-line 0 to darken and < 0 to auto hide (grep rephide)
        return Int(result)
    }
    
    private func log10(_ str: String) -> Double {
        let leadingDigits   =   Int(str.dropLast(str.count - 4))!
        let logarithm       =   log(Double(leadingDigits)) / M_LN10 + 0.00000001
        let intPart         =   str.count - 1
        
        return Double(intPart) + Double(logarithm.truncatingRemainder(dividingBy: 1))
    }
}
