//
//  UIImageView+Extensions.swift
//  Golos
//
//  Created by msm72 on 13.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import Kingfisher
import SwiftGifOrigin

enum ImageType: String {
    case defaultImage
    case userCoverImage
    case userProfileImage
}

extension UIImageView {
    /// Upload image
    func uploadImage(byStringPath path: String, imageType: ImageType, size: CGSize, tags: [String]?) {
        // Cover as 'NSFW'
        if let tagsTemp = tags, tagsTemp.map({ $0.lowercased() }).contains("nsfw"), imageType == .userCoverImage {
            self.image = UIImage(named: "nsfw")!
        }
        
        else {
            let imagePath               =   path.addImageProxy(withSize: size)
            let imagePlaceholderName    =   imageType == .defaultImage ? "image-placeholder" : (imageType == .userProfileImage ?    "icon-user-profile-image-placeholder" :
                                                                                                                                    "image-user-cover-placeholder")
            
            let imageKey                =   imageType.rawValue + "-" + imagePath
            
            if imagePath.hasSuffix(".gif") {
                var gifImage: UIImage?

                if isNetworkAvailable {
                    gifImage = UIImage.gif(url: imagePath)
                    
                    let images = [gifImage!] as NSArray
                    PINCache.shared().setObject(images, forKey: imageKey)
                }
                
                // Cache .gif
                else {
                    PINCache.shared().object(forKey: imageKey) { _, _, object in
                        if let images = object as? [UIImage] {
                            gifImage = images.first
                        }
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.image = gifImage
                }
            }
            
            else {
                self.kf.setImage(with:                  ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imageKey),
                                 placeholder:           UIImage(named: imagePlaceholderName)!,
                                 options:               [.transition(ImageTransition.fade(1)),
                                                         .processor(ResizingImageProcessor(referenceSize:   size,
                                                                                           mode:            .aspectFill))],
                                 completionHandler:     { image, error, _, _ in
                                    if error == nil {
                                        if imageType == .userCoverImage {
                                            self.contentMode = image!.size.width > image!.size.height ? .scaleAspectFill : .scaleAspectFit
                                        }
                                        
                                        self.kf.cancelDownloadTask()
                                    }
                })
            }
        }
    }
}
