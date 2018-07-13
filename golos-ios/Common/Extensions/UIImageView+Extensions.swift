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

extension UIImageView {
    /// Upload image
    func uploadImage(byStringPath path: String, avatarImage: Bool, size: CGSize, tags: [String]?) {
        // Cover as 'NSFW'
        if let tagsTemp = tags, tagsTemp.map({ $0.lowercased() }).contains("nsfw"), !avatarImage {
            self.image = UIImage(named: "nsfw")!
        }
        
        else {
            let imagePath = path.addImageProxy(withSize: size)
            
            self.kf.setImage(with:                  ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
                             placeholder:           UIImage(named: avatarImage ? "icon-user-profile-image-placeholder" : "image-placeholder")!,
                             options:               [.transition(ImageTransition.fade(1)),
                                                     .processor(ResizingImageProcessor(referenceSize:   size,
                                                                                       mode:            .aspectFill))],
                             completionHandler:     { image, error, _, _ in
                                if error == nil {
                                    if !avatarImage {
                                        self.contentMode = max(image!.size.width, image!.size.height) <= size.width ? .scaleAspectFill : .scaleAspectFit
                                    }
                                    
                                    self.kf.cancelDownloadTask()
                                }
            })
        }
    }
}
