import UIKit

func bytesReverse(uint64: UInt64) -> [UInt8] {
    return [UInt8(truncatingIfNeeded: uint64), UInt8(truncatingIfNeeded: uint64 >> 8)]
}

//func bytesReverse(int64: Int64) -> [UInt8] {
//    return [UInt8(truncatingIfNeeded: int64), UInt8(truncatingIfNeeded: int64 >> 8)]
//}

func bytesDirect(int64: Int64) -> [UInt8] {
    return [UInt8(truncatingIfNeeded: int64 >> 8), UInt8(truncatingIfNeeded: int64)]
}

//let reverseInt = bytesReverse(int64: 10_000)
//// 1027
//print(reverseInt)

let directInt = bytesDirect(int64: 10_000)
//2710
print(directInt)


let fff = UInt64(bitPattern: -10_000)
print(bytesReverse(uint64: fff))
// f0d8

//let regex = "[^а-я0-9a-z,ґ,є,і,ї,-]"
//var temp = "hi,-thi.,s-is-⚡️ jjj авбгдка🔥☄️"
//    //"hajdh-ja%6ma-na-000-=+-adjas-$$$$ :-)"
//
//temp = temp.replacingOccurrences(of: regex, with: "", options: .regularExpression)//.replacingOccurrences(of: "--", with: "-")
//
//print(temp)
