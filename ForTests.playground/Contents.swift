import UIKit

let regex = "[^а-я0-9a-z,ґ,є,і,ї,-]"
var temp = "hi,-thi.,s-is-⚡️ jjj авбгдка🔥☄️"
    //"hajdh-ja%6ma-na-000-=+-adjas-$$$$ :-)"

temp = temp.replacingOccurrences(of: regex, with: "", options: .regularExpression)//.replacingOccurrences(of: "--", with: "-")

print(temp)
