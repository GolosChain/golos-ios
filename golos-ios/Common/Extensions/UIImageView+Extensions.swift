//
//  UIImageView+Extensions.swift
//  Golos
//
//  Created by msm72 on 13.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
//import Kingfisher
import SwiftGifOrigin

enum ImageType: String {
    case defaultImage
    case userCoverImage
    case userProfileImage
}

extension UIImageView {
    /// Download image
    func uploadImage(byStringPath path: String, imageType: ImageType, size: CGSize, tags: [String]?, createdDate: Date, fromItem: String) {
        let imagePathWithProxy      =   path.trimmingCharacters(in: .whitespacesAndNewlines).addImageProxy(withSize: size)
        let imageURL                =   URL(string: imagePathWithProxy.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        
        Logger.log(message: "imageURL = \(imageURL!)", event: .debug)
        
        let imagePlaceholderName    =   imageType == .defaultImage ? "image-placeholder" : (imageType == .userProfileImage ?    "icon-user-profile-image-placeholder" :
                                                                                                                                "image-user-cover-placeholder")
        
        let imageKey: NSString      =   imageURL!.absoluteString as NSString //imageType.rawValue + "-" + imagePath as NSString

        // Cover as 'NSFW'
        if let tagsTemp = tags, tagsTemp.map({ $0.lowercased() }).contains("image-nsfw"), imageType == .userCoverImage {
            self.image = UIImage(named: "image-nsfw")!
        }

        else {
            // Get image from NSCache
            if let cachedImage = cacheApp.object(forKey: imageKey) {
                if imageType == .userCoverImage {
                    self.contentMode = cachedImage.size.width > cachedImage.size.height ? .scaleAspectFill : .scaleAspectFit
                }

                UIView.animate(withDuration: 0.5) {
                    self.image = cachedImage
                }
            }
            
            else {
                // Download .gif
                if imagePathWithProxy.hasSuffix(".gif"), let imageGIF = UIImage.gif(url: imagePathWithProxy) {
                    // Save image to NSCache
                    cacheApp.setObject(imageGIF, forKey: imageKey)
                    
                    DispatchQueue.main.async {
                        self.image = imageGIF
                    }
                }

                // Download image by URL
                else if isNetworkAvailable {
                    URLSession.shared.dataTask(with: imageURL!) { data, _, error in
                        guard error == nil else {
                            DispatchQueue.main.async {
                                self.image = UIImage(named: imagePlaceholderName) //imageType != .userCoverImage ? UIImage(named: imagePlaceholderName) : nil
                            }
                            
                            return
                        }
                        
                        if let data = data, let downloadedImage = UIImage(data: data) {
                            if imageType == .userCoverImage {
                                self.contentMode = downloadedImage.size.width > downloadedImage.size.height ? .scaleAspectFill : .scaleAspectFit
                            }
                            
                            DispatchQueue.main.async {
                                if downloadedImage.isEqualTo(image: UIImage(named: "image-mock-white")!) {
                                    self.image  =   UIImage(named: imagePlaceholderName)
                                }
                                
                                else {
                                    self.image  =   downloadedImage
                                }
                                
                                // Save image to NSCache
                                cacheApp.setObject(self.image!, forKey: imageKey)
                            }
                            
                            // Save ImageCached to CoreData
                            DispatchQueue.main.async {
                                ImageCached.updateEntity(fromItem: fromItem, byDate: createdDate, andKey: imageKey as String)
                            }
                        }
                    }.resume()
                }
                
                else {
                    DispatchQueue.main.async {
                        self.image = UIImage(named: imagePlaceholderName)
                    }
                }
            }
        }
    }
}
