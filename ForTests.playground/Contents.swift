import UIKit

var x = "Раз два 9 три % ;;;;; ? <> море за рекой"  //"1293812908-()*7-7sdajsdj-?-<>"
let regex = "[^а-я0-9a-z,ґ,є,і,ї]"

x = x.replacingOccurrences(of: regex, with: "_", options: .regularExpression)

print(x)
