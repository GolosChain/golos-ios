import Foundation

func log10(_ str: String) -> Double {
    let leadingDigits   =   Int(str.dropLast(str.count - 4))!
    let logarithm       =   log(Double(leadingDigits)) / M_LN10 + 0.00000001
    let n               =   str.count - 1
    
    return Double(n) + Double(logarithm.truncatingRemainder(dividingBy: 1))
}

func repLog10(_ rep2: String) -> Int {
    if rep2 == "0" {
        return 0
    }
    
    let neg     =   rep2.hasPrefix("-")
    let rep     =   neg ? String(rep2[rep2.index(rep2.startIndex, offsetBy: 1)...]) : rep2
    var out     =   log10(rep)
    
    if out.isNaN {
        return 0
    }
    
    // @ -9, $0.50 earned is approx magnitude 1
    out         =   max(out - 9, 0)
    out         *=  (neg ? -1 : 1)
    
    // 9 points per magnitude. center at 25
    out         =   out * 9 + 25
    
    // base-line 0 to darken and < 0 to auto hide (grep rephide)
    return Int(out)
}

let reputation = "1507103961220"
let result = repLog10(reputation)
