import UIKit

var someString = "<html>\n\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![](https://images.golos.io/DQmeHx5DUYV1xkLpwSPjvYb4qgqosnmq9QoghR4rQjkDjYA/image.png)\" alt=\"image.png\" width=\"500\" height=\"330\"<br>\nОна"

let rangeOpenCurl = someString.range(of: " alt=")
let rangeCloseCurl = someString.range(of: "<br>")

if let startLocation = rangeOpenCurl?.lowerBound, let endLocation = rangeCloseCurl?.lowerBound {
    someString.replaceSubrange(startLocation ..< endLocation, with: "")
}

print(someString)
