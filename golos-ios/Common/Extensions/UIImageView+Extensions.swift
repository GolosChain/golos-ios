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
            let imagePath = path.addImageProxy(withSize: size)
            let imagePlaceholderName = imageType == .defaultImage ? "image-placeholder" : (imageType == .userProfileImage ? "icon-user-profile-image-placeholder" : "image-user-cover-placeholder")
                
            self.kf.setImage(with:                  ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
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
