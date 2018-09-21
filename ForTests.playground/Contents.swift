import UIKit

let translateLatinChars             =   "abcdefghijklmnopqrstuvwxyz0123456789-,.?"
let translateCyrillicChars          =   "йцукенгшщзхъёфывапролджэячсмитьбюґєії0123456789-,.?"

let cyrillicChars   =   [ "щ", "ш", "ч", "ц", "й", "ё", "э", "ю", "я", "х", "ж", "а", "б", "в", "г", "д", "е", "з", "и", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "ъ", "ы", "ь", "ґ", "є", "і", "ї" ]

let latinChars      =   [ "shch", "sh", "ch", "cz", "ij", "yo", "ye", "yu", "ya", "kh", "zh", "a", "b", "v", "g", "d", "e", "z", "i", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u", "f", "xx", "y", "x", "g", "e", "i", "i" ]

func isCyrillic(text: String) -> Bool {
    for char in text.lowercased().map({ String($0) }) {
        if translateCyrillicChars.contains(char) && !translateLatinChars.contains(char) {
            return true
        }
    }
    
    return false
}

func transliterate(char: String, isCyrillic: Bool) -> String {
    let convertDict     =   isCyrillic ?    NSDictionary.init(objects: latinChars, forKeys: cyrillicChars as [NSCopying]) :
        NSDictionary.init(objects: cyrillicChars, forKeys: latinChars as [NSCopying])
    
    return convertDict.value(forKey: char.lowercased()) as! String
}

func transliterationInLatin(text: String) -> String {
    guard !text.contains("ru--") else {
        return text.replacingOccurrences(of: "ru--", with: "")
    }
    
    let words: [String]     =   text.components(separatedBy: " ")
    var newWords: [String]  =   [String]()
    
    words.forEach({ word in
        if isCyrillic(text: word) {
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

let testStr = "Тикет 75 тест 1"
print(transliterationInLatin(text: testStr))
