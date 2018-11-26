//
//  PostParser.swift
//  Golos
//
//  Created by Grigory on 16/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//
//  https://regexr.com/3g1v7
//

import Down
import GoloSwift
import Foundation

class Parser {    
    static func getPictureURL(fromBody body: String) -> String? {
        let pattern     =   "(http(s?):)([/|.|\\w|\\s|\\%|\\-|\\_|\\()])*\\.(?:jpg|JPG|jpeg|JPEG|gif|GIF|png|PNG)(!d)?"
        
        let regex       =   try! NSRegularExpression(pattern: pattern)
        let results     =   regex.matches(in:       body,
                                          range:    NSRange.init(location: 0, length: body.count))
        
        guard let match = results.first else {
            return nil
        }

        return (body as NSString).substring(with: match.range)
    }
    
    func getDescription(from body: String) -> String {
        let down = Down(markdownString: body)
        let html = try! down.toHTML()
        var cleanBody = html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cleanBody = cleanBody.replacingOccurrences(of: "&.*;", with: "", options: .regularExpression, range: nil)
        cleanBody = cleanBody.replacingOccurrences(of: "\n", with: "")
        
//        let pattern = "\\bhttps?:[^)''\"]+\\.(?:jpg|jpeg|gif|png)(!d)?"
        let linkPatter = "(http(s?):)([/|.|\\w|\\s|-])*"
        cleanBody = cleanBody.replacingOccurrences(of: linkPatter, with: "", options: .regularExpression, range: nil)
        
        let index = cleanBody.index(cleanBody.startIndex, offsetBy: min(200, cleanBody.count))
        cleanBody = String(cleanBody[..<index])
//        cleanBody = cleanBody.substring(to: index)

        return cleanBody //String(cleanBody[...index])
    }
    
    func repairBody(_ body: String) -> String {
        let mutableString = NSMutableString(string: body)
        let imageUrlPattern = "(https?:\\/\\/.*\\.(?:png|jpg))"
        let mdImagePattern = "!{0,1}(?:\\[.*\\])*\\({0,1}(https?:\\/\\/.*\\.(?:png|jpg))\\){0,1}"
        
        let urlRegex = try! NSRegularExpression(pattern: imageUrlPattern, options: [])
        let mdImageRegex = try! NSRegularExpression(pattern: mdImagePattern, options: [])
        
        var newString = ""
        var start = 0
        
        while start < body.count {
            if let match = mdImageRegex.firstMatch(in: body, options: [], range: NSRange(location: start, length: body.count-start)) {
                
                let range = NSRange.init(location: start, length: match.range.location - start)
                let text = mutableString.substring(with: range).count > 0 ? mutableString.substring(with: range) : ""
                
                var img = (body as NSString).substring(with: match.range)
                
                let imgimg = urlRegex.firstMatch(in: img, options: [], range: NSRange.init(location: 0, length: img.count))!
                img = (img as NSString).substring(with: imgimg.range)
                
                img = "\(newString.contains(img) ? "" : "!")[](\(img))"

                newString.append(text)
                newString.append(img)
                start = match.range.location + match.range.length
            }
            
            else {
                let range = NSRange.init(location: start, length: body.count-start)
                let text = mutableString.substring(with: range)
               
                newString.append(text)
                start += body.count-start
            }
        }
        
        return newString
    }
    
    static func repair(body: String) -> String {
        var modifiedBody = body
        
        // Modify YouTube video link
        if modifiedBody.contains("https://www.youtube.com/") || modifiedBody.contains("https://youtu.be/") {
            var youTubeImageLink: String?
            var youTubeVideoLink: String?
            
            let youTubeImagePattern     =   "http(?:s?):\\/\\/(?:www\\.)?youtu(?:be\\.com\\/watch\\?v=|\\.be\\/)([\\w\\-\\_]*)(&(amp;)?‌​[\\w\\?‌​=]*)?"
            let youTubeVideoPattern     =   "http(?:s?):\\/\\/(?:www\\.)?youtu(?:be\\.com\\/watch\\?v=|\\.be\\/)([\\w\\-\\_\\&\\=]*)(&(amp;)?‌​[\\w\\?‌​=]*)?"

            var youTubeRegEx            =   try! NSRegularExpression(pattern: youTubeImagePattern)
            
            var results                 =   youTubeRegEx.matches(in:        modifiedBody,
                                                                 range:     NSRange.init(location: 0, length: modifiedBody.count))
            
            if let result = results.first {
                youTubeImageLink        =   (modifiedBody as NSString).substring(with: result.range)
            }
            
            youTubeRegEx                =   try! NSRegularExpression(pattern: youTubeVideoPattern)
            
            results                     =   youTubeRegEx.matches(in:        modifiedBody,
                                                                 range:     NSRange.init(location: 0, length: modifiedBody.count))
            
            if let result = results.first {
                youTubeVideoLink        =   (modifiedBody as NSString).substring(with: result.range)

                modifiedBody = youTubeRegEx.stringByReplacingMatches(in: modifiedBody, options: .withTransparentBounds, range: NSRange(location: 0, length: modifiedBody.count), withTemplate: String(format: "[![](https://img.youtube.com/vi/%@/0.jpg)](%@)", youTubeImageLink!.components(separatedBy: "=").last!, youTubeVideoLink!))
            }
        }
        
        if modifiedBody.contains("//pp.userapi.com") {
            modifiedBody = modifiedBody.replacingOccurrences(of: "//pp.userapi.com", with: "//imgp.golos.io/0x0/https://pp.userapi.com")
        }
        
        if modifiedBody.contains("(![](") {
            modifiedBody = modifiedBody.replacingOccurrences(of: "(![](", with: "(").replacingOccurrences(of: "))", with: ")\n")
        }
        
        // Delete alt
        if modifiedBody.contains("alt") {
            let rangeStart  =   modifiedBody.range(of: " alt=")
            let rangeEnd    =   modifiedBody.range(of: "<br>")
            
            if let startLocation = rangeStart?.lowerBound, let endLocation = rangeEnd?.lowerBound, startLocation <= endLocation {
                modifiedBody.replaceSubrange(startLocation ..< endLocation, with: "")
                modifiedBody = modifiedBody.replacingOccurrences(of: "\"<br>", with: "<br>")
            }
        }

        // Delete center
        modifiedBody = modifiedBody.replacingOccurrences(of: "<center>http", with: "![](http")
        modifiedBody = modifiedBody.replacingOccurrences(of: "</center>", with: ")")

        // Delete <div class=\"pull-left\"> http
        modifiedBody = modifiedBody.replacingOccurrences(of: "<div class=\"pull-left\"> http", with: "![](http")
        modifiedBody = modifiedBody.replacingOccurrences(of: "</div>", with: ")")

        // Delete @userName in link
        let userNamePattern         =   "\\/\\[\\@(\\w*\\W?\\w*)\\]\\("
        let userNameRegex           =   try! NSRegularExpression(pattern: userNamePattern, options: [])
        var userName: String        =   "XXX"
        
        if let userNameMatches = userNameRegex.firstMatch(in: modifiedBody, options: .withTransparentBounds, range: NSRange(location: 0, length: modifiedBody.count)) {
            userName = (modifiedBody as NSString).substring(with: NSRange(location:  userNameMatches.range.location + 3, length:  userNameMatches.range.length - 5))
        }

        let userNameLinkPattern     =   "\\/\\[\\@\\w*\\W?\\w*\\]\\(\\@\\w*\\W?\\w*\\)\\/"

        if userName != "XXX", let regex = try? NSRegularExpression(pattern: userNameLinkPattern, options: .caseInsensitive) {
            modifiedBody    =   regex.stringByReplacingMatches(in: modifiedBody, options: .withTransparentBounds, range: NSRange(location: 0, length: modifiedBody.count), withTemplate: "/\(userName)/")
//            modifiedBody    =   modifiedBody.replacingOccurrences(of: ")](", with: ")\n(")
        }

        return modifiedBody
    }
}
