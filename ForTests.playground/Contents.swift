import Foundation

let tags = ["test1", "test2"]
let stringTags    =   ("{\"tags\":[\"" + tags.joined(separator: ",") + "\"]")
    .replacingOccurrences(of: ",", with: "\",\"") + ",\"app\":\"golos.io/0.1\",\"format\":\"markdown\"}"

print(stringTags)
