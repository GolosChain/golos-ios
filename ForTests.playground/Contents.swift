import UIKit

// https://medium.com/makingtuenti/writing-a-lightweight-markup-parser-in-swift-5c8a5f0f793f

enum MarkupNode {
    case text(String)
    case strong([MarkupNode])
    case emphasis([MarkupNode])
    case delete([MarkupNode])
}

public struct MarkupParser {
    public static func parse(text: String) -> [MarkupNode] {
        var parser = MarkupParser(text: text)
        return parser.parse()
    }
    
    private var tokenizer: MarkupTokenizer
    private var openingDelimiters: [UnicodeScalar] = []
    
    private init(text: String) {
        tokenizer = MarkupTokenizer(string: text)
    }
    
//    private mutating func parse() -> [MarkupNode] {
//        
//    }
}
