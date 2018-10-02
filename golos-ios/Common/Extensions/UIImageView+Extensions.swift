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
        let uploadedSize            =   CGSize(width: size.width * 3, height: size.height * 3)
        self.alpha                  =   0.0
        
        let imagePathWithProxy      =   path.trimmingCharacters(in: .whitespacesAndNewlines).addImageProxy(withSize: uploadedSize)
        let imageURL                =   URL(string: imagePathWithProxy)
        
        Logger.log(message: "imageURL = \(imageURL!)", event: .debug)
        
        let imagePlaceholderName    =   imageType == .defaultImage ? "image-placeholder" : (imageType == .userProfileImage ?    "icon-user-profile-image-placeholder" :
                                                                                                                                "image-user-cover-placeholder")
        
        let imageKey: NSString      =   imageURL!.absoluteString as NSString

        // Cover as 'NSFW'
        if let tagsTemp = tags, tagsTemp.map({ $0.lowercased() }).contains("image-nsfw"), imageType == .userCoverImage {
            self.image = UIImage(named: "image-nsfw")!
        }

        else {
            // Get image from NSCache
            if let cachedImage = cacheApp.object(forKey: imageKey) {
                let getImageFromCacheQueue = DispatchQueue.global(qos: .background)
                
                // Run queue in Async Thread
                getImageFromCacheQueue.async {
                    if imageType == .userCoverImage {
                        self.contentMode = cachedImage.size.width > cachedImage.size.height ? .scaleAspectFill : .scaleAspectFit
                    }
                    
                    self.fadeIn(image: cachedImage)
                }
            }
                
            else {
                // Download .gif
                if imagePathWithProxy.hasSuffix(".gif") {
                    let downloadGIFQueue = DispatchQueue.global(qos: .background)
                
                    // Run queue in Async Thread
                    downloadGIFQueue.async {
                        if let imageGIF = UIImage.gif(url: imagePathWithProxy) {
                            // Save image to NSCache
                            cacheApp.setObject(imageGIF, forKey: imageKey)
                        
                            self.fadeIn(image: imageGIF)
                        }
                    }
                }
                    
                // Download image by URL
                else if isNetworkAvailable {
                    let downloadImageQueue = DispatchQueue.global(qos: .utility)
                    
                    // Run queue in Async Thread
                    downloadImageQueue.async {
                        URLSession.shared.dataTask(with: imageURL!) { data, _, error in
                            guard error == nil else {
                                self.fadeIn(image: UIImage(named: imagePlaceholderName)!)
                                return
                            }
                            
                            if let data = data, let downloadedImage = UIImage(data: data) {
                                if imageType == .userCoverImage {
                                    self.contentMode = downloadedImage.size.width > downloadedImage.size.height ? .scaleAspectFill : .scaleAspectFit
                                }
                                
                                if downloadedImage.isEqualTo(image: UIImage(named: "image-mock-white")!) {
                                    self.fadeIn(image: UIImage(named: imagePlaceholderName)!)
                                }
                                    
                                else {
                                    self.fadeIn(image: downloadedImage)
                                }
                                
                                // Save image to NSCache
                                let saveImageToCacheQueue = DispatchQueue.global(qos: .background)
                                
                                saveImageToCacheQueue.async {
                                    cacheApp.setObject(downloadedImage, forKey: imageKey)
                                }
                                
                                // Save ImageCached to CoreData
                                let saveImageToCoreDataQueue = DispatchQueue.global(qos: .background)
                                
                                saveImageToCoreDataQueue.async {
                                    ImageCached.updateEntity(fromItem: fromItem, byDate: createdDate, andKey: imageKey as String)
                                }
                            }
                        }.resume()
                    }
                }
                    
                else {
                    self.fadeIn(image: UIImage(named: imagePlaceholderName)!)
                }
            }
        }
    }
    
    private func fadeIn(image: UIImage) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.image = image

            UIView.animate(withDuration: 0.75, animations: {
                self.alpha = 1.0
            })
        })
    }
}
