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
    func uploadImage(byStringPath path: String, imageType: ImageType, size: CGSize, tags: [String]?) {
        let imagePathWithProxy      =   path.trimmingCharacters(in: .whitespacesAndNewlines).addImageProxy(withSize: size)
        let imageURL                =   URL(string: imagePathWithProxy)
        let imagePlaceholderName    =   imageType == .defaultImage ? "image-placeholder" : (imageType == .userProfileImage ?    "icon-user-profile-image-placeholder" :
                                                                                                                                "image-user-cover-placeholder")
        
        let imageKey: NSString      =   imageURL!.absoluteString as NSString //imageType.rawValue + "-" + imagePath as NSString

        // Cover as 'NSFW'
        if let tagsTemp = tags, tagsTemp.map({ $0.lowercased() }).contains("nsfw"), imageType == .userCoverImage {
            self.image = UIImage(named: "nsfw")!
        }

        else {
            // Get image from NSCache
            if let cachedImage = cacheApp.object(forKey: imageKey) {
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
                else {
                    URLSession.shared.dataTask(with: imageURL!) { data, _, error in
                        guard error == nil else {
                            DispatchQueue.main.async {
                                self.image = imageType != .userCoverImage ? UIImage(named: imagePlaceholderName) : nil
                            }
                            
                            return
                        }
                        
                        if let data = data, let downloadedImage = UIImage(data: data) {
                            if imageType == .userCoverImage {
                                self.contentMode = downloadedImage.size.width > downloadedImage.size.height ? .scaleAspectFill : .scaleAspectFit
                            }

                            // Save image to NSCache
                            cacheApp.setObject(downloadedImage, forKey: imageKey)
                            
                            DispatchQueue.main.async {
                                self.image = downloadedImage
                            }
                        }
                        }.resume()
                }
            }
        }
    }
}
