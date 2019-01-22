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
    func uploadImage(byStringPath path: String, imageType: ImageType, size: CGSize, tags: [String]?, createdDate: Date, fromItem: String, isCurrentUserAuthor: Bool = false, completion: @escaping (CGFloat) -> Void) {
        let uploadedSize            =   CGSize(width: size.width, height: size.height)
        let imagePathWithProxy      =   path.trimmingCharacters(in: .whitespacesAndNewlines).addImageProxy(withSize: uploadedSize)
        
        guard let imageURL = URL(string: imagePathWithProxy) else {
            return
        }
        
        Logger.log(message: "imageURL = \(imageURL)", event: .debug)
        
        let imagePlaceholderName    =   imageType == .defaultImage ? "image-placeholder" : (imageType == .userProfileImage ?    "icon-user-profile-image-placeholder" :
                                                                                                                                "image-user-cover-placeholder")
        
        let imageKey: NSString      =   imageURL.absoluteString as NSString

        // Cover as 'NSFW'
        if let tagsTemp = tags, tagsTemp.map({ $0.lowercased() }).contains("nsfw"), imageType == .userCoverImage, !isCurrentUserAuthor {
            self.image = UIImage(named: "image-nsfw")!
            self.accessibilityIdentifier = imageURL.absoluteString
        }

        else {
            // Get image from NSCache
            if let cachedImage = cacheApp.object(forKey: imageKey) {
                let getImageFromCacheQueue = DispatchQueue.global(qos: .background)
                
                // Run queue in Async Thread
                getImageFromCacheQueue.async {
                    if imageType == .userCoverImage {
                        self.contentMode = .scaleAspectFill
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                        completion(cachedImage.sidesAspectRatio())
                    })
                    
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
                        
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                                completion(imageGIF.sidesAspectRatio())
                            })
                            
                            self.fadeIn(image: imageGIF)
                        }
                    }
                }
                    
                // Download image by URL
                else if isNetworkAvailable {
                    let downloadImageQueue = DispatchQueue.global(qos: .utility)
                    
                    // Run queue in Async Thread
                    downloadImageQueue.async {
                        URLSession.shared.dataTask(with: imageURL) { data, _, error in
                            guard error == nil else {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                                    completion(UIImage(named: imagePlaceholderName)!.sidesAspectRatio())
                                })
                                
                                self.fadeIn(image: UIImage(named: imagePlaceholderName)!)
                                return
                            }
                            
                            if let data = data, let downloadedImage = UIImage(data: data) {
                                if imageType == .userCoverImage {
                                    self.contentMode = .scaleAspectFill
                                }
                                
                                if downloadedImage.isEqualTo(image: UIImage(named: "image-mock-white")!) {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                                        completion(UIImage(named: imagePlaceholderName)!.sidesAspectRatio())
                                    })
                                    
                                    self.fadeIn(image: UIImage(named: imagePlaceholderName)!)
                                }
                                    
                                else {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                                        completion(downloadedImage.sidesAspectRatio())
                                    })
                                                                        
                                    self.fadeIn(image: downloadedImage)
                                }
                                
                                // Save image to NSCache
//                                let saveImageToCacheQueue = DispatchQueue.global(qos: .background)
                                
//                                saveImageToCacheQueue.async {
                                    cacheApp.setObject(downloadedImage, forKey: imageKey)
//                                }
                                
                                // Save ImageCached to CoreData
//                                let saveImageToCoreDataQueue = DispatchQueue.global(qos: .background)

//                                saveImageToCoreDataQueue.async {
                                DispatchQueue.main.async(execute: {
                                    ImageCached.updateEntity(fromItem: fromItem, byDate: createdDate, andKey: imageKey as String)
                                })
//                                }
                            }
                        }.resume()
                    }
                }
                    
                else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                        completion(UIImage(named: imagePlaceholderName)!.sidesAspectRatio())
                    })

                    self.fadeIn(image: UIImage(named: imagePlaceholderName)!)
                }
            }
        }
    }
    
    private func fadeIn(image: UIImage) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
            UIView.transition(with:         self,
                              duration:     0.75,
                              options:      .transitionCrossDissolve,
                              animations:   { self.image = image },
                              completion:   nil)
        })
    }
    
    func setTemplate(type: ImageType) {
        switch type {
        case .userProfileImage:
            self.image = UIImage(named: "icon-user-profile-image-placeholder")

        case .userCoverImage:
            self.image = UIImage(named: "image-user-cover-placeholder")

        default:
            self.image = UIImage(named: "image-placeholder")
        }
        
//        self.layer.cornerRadius =   cornerRadius
//        self.clipsToBounds      =   true
    }
}
