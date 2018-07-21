//
//  NSManagedObject+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 23.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

extension NSManagedObject {
    func save() {
        CoreDataManager.instance.contextSave()
    }
    
    func parse(metaData: String?, fromModel model: ResponseAPIFeed) {
        if let jsonMetaData = metaData, !jsonMetaData.isEmpty, let jsonData = jsonMetaData.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                    (self as! MetaDataSupport).set(tags: json["tags"] as? [String])
                    
                    if let imageURL = (json["image"] as? [String])?.first {
                        (self as! MetaDataSupport).set(coverImageURL: imageURL)
                    }
                        
                    else {
                        do {
                            let input       =   model.body
                            let detector    =   try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                            let matches     =   detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                            
                            for match in matches {
                                guard let range = Range(match.range, in: input) else {
                                    continue
                                }
                                
                                let url     =   input[range]
                                
                                Logger.log(message: "url = \(url)", event: .debug)
                                
                                if (url.hasSuffix(".jpg") || url.hasSuffix(".png") || url.hasSuffix(".gif")) && (self as! MetaDataSupport).coverImageURLValue == nil {
                                    (self as! MetaDataSupport).set(coverImageURL: "\(url)")
                                    Logger.log(message: "coverImageURL = \(url)", event: .debug)
                                }
                            }
                        } catch {
                            // contents could not be loaded
                            (self as! MetaDataSupport).set(coverImageURL: nil)
                        }
                    }
                    
                    // Extensions
                    self.save()
                }
            } catch {
                Logger.log(message: "JSON serialization error", event: .error)
                
                // Extensions
                self.save()
            }
        }
            
        else {
            // Extensions
            self.save()
        }
    }
}
