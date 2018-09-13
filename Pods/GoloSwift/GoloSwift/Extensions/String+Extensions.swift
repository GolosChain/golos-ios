//
//  String+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation
import Localize_Swift

let cyrillicChars   =   [ "щ", "ш", "ч", "ц", "й", "ё", "э", "ю", "я", "х", "ж", "а", "б", "в", "г", "д", "е", "з", "и", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "ъ", "ы", "ь", "ґ", "є", "і", "ї" ]

// https://github.com/GolosChain/tolstoy/blob/master/app/utils/ParsersAndFormatters.js#L117
// https://github.com/GolosChain/tolstoy/blob/master/app/utils/ParsersAndFormatters.js#L121
let latinChars      =   [ "shch", "sh", "ch", "cz", "ij", "yo", "ye", "yu", "ya", "kh", "zh", "a", "b", "v", "g", "d", "e", "z", "i", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u", "f", "xx", "y", "x", "g", "e", "i", "i" ]


let translateLatinChars             =   "abcdefghijklmnopqrstuvwxyz0123456789-,.?"
let translateCyrillicChars          =   "йцукенгшщзхъёфывапролджэячсмитьбюґєії0123456789-,.?"


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
    var isCyrillic: Bool {
        for char in self.lowercased().map({ String($0) }) {
            if translateCyrillicChars.contains(char) && !translateLatinChars.contains(char) {
                return true
            }
        }
        
        return false
    }
    
    
    /// Common transliteration with App language support
    public func transliteration() -> String {
        return Localize.currentLanguage() == "en" ? transliterationInLatin() : transliterationInCyrillic()
    }
    
    
    /// Cyrillic -> Latin
    private func transliterationInLatin() -> String {
        guard !self.contains("ru--") else {
            return self.replacingOccurrences(of: "ru--", with: "")
        }
        
        let words: [String]     =   self.components(separatedBy: " ")
        var newWords: [String]  =   [String]()
        
        words.forEach({ word in
            if word.isCyrillic {
                var newString: String = ""
                var latinChar: String
                
                for char in word {
                    latinChar = transliterate(char: "\(char)", isCyrillic: true)
                    newString.append(latinChar)
                }
                
                newWords.append(newString)
            }
                
            else {
                newWords.append(word)
            }
        })
        
        return newWords.joined(separator: " ")
    }
    
    
    /// Latin -> Cyrillic
    private func transliterationInCyrillic() -> String {
        guard self.contains("ru--") else {
            return self
        }
        
        var newString: String   =   self.replacingOccurrences(of: "ru--", with: "")
        let words: [String]     =   newString.components(separatedBy: " ")
        
        words.forEach({ word in
            if !word.isCyrillic {
                var cyrillicChar: String
                
                for lenght in (1...4).reversed() {
                    for char in latinChars.filter({ $0.count == lenght }) {
                        cyrillicChar    =   transliterate(char: "\(char)", isCyrillic: false)
                        newString       =   newString.replacingOccurrences(of: char, with: cyrillicChar)
                    }
                }
            }
        })
        
        return newString
    }
    
    func transliterate(char: String, isCyrillic: Bool) -> String {
        let convertDict     =   isCyrillic ?    NSDictionary.init(objects: latinChars, forKeys: cyrillicChars as [NSCopying]) :
            NSDictionary.init(objects: cyrillicChars, forKeys: latinChars as [NSCopying])
        
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
