import UIKit

let arrays = ["l1", "l2", "l3", "l11", "l22", "l41"]

let sorted = arrays.sorted(by: { $0 < $1 })

print(sorted)
