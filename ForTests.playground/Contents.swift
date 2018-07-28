import UIKit

//func isCyrillic(string: String) -> Bool {
//    let upper = "ЙЦУКЕНГШЩЗХЪЁФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"
//    let lower = "йцукенгшщзхъёфывапролджэячсмитьбю"
//    
//    for char in string.map({ String($0) }) {
//        if !upper.contains(char) && !lower.contains(char) {
//            return false
//        }
//    }
//    
//    return true
//}
//
///// Cyrillic -> Latin
//public func transliterationInLatin(string: String) -> String {
//    var result: String
//    let words: [String] = string.components(separatedBy: " ")
//    
//    words.forEach({ transliterationInLatin(string: $0) })
//    
//    for word in words {
//        result += isCyrillic(string: word)
//    }
//    guard isCyrillic(string: string) else {
//        return string
//    }
//    
//    var newString: String = ""
//    var latinChar: String
//    
//    for char in string {
//        latinChar = transliterate(char: "\(char)")
//        newString.append(latinChar)
//    }
//    
//    return newString
//}
//
//func transliterate(char: String) -> String {
//    let cyrillicChars   =   [ "щ", "ш", "ч", "ц", "й", "ё", "э", "ю", "я", "х", "ж", "а", "б", "в", "г", "д", "е", "з", "и", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "ъ", "ы", "ь", "ґ", "є", "і", "ї" ]
//    
//    // https://github.com/GolosChain/tolstoy/blob/master/app/utils/ParsersAndFormatters.js#L117
//    let latinChars      =   [ "shch", "sh", "ch", "cz", "ij", "yo", "ye", "yu", "ya", "kh", "zh", "a", "b", "v", "g", "d", "e", "z", "i", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u", "f", "xx", "y", "x", "g", "e", "i", "i" ]
//    
//    let convertDict     =   NSDictionary.init(objects: latinChars, forKeys: cyrillicChars as [NSCopying])
//    
//    return convertDict.value(forKey: char.lowercased()) as! String
//}
//
//
//
//print(transliterationInLatin(string: "это пост"))
