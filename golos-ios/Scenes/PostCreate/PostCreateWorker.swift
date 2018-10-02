//
//  PostCreateWorker.swift
//  golos-ios
//
//  Created by msm72 on 01.08.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

class PostCreateWorker {
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business Logic
    func createSignatures(forImagesIn attachments: [Attachment], completion: @escaping ([Attachment]) -> Void) {
        var imagesAttachments   =  attachments
        
        for (index, imageAttachment) in imagesAttachments.enumerated() {
            // Create image signature
            if let image = imageAttachment.origin as? UIImage, let imageSignature = Attachment.createURL(forImage: image, userNickName: User.current!.nickName) {
                var repeatCount: CGFloat        =   -0.2
                var uploadedImage: UIImage      =   image
                var uploadedImageSize: CGFloat  =   1500.0
                repeat {
                    repeatCount                 +=  0.2
                    uploadedImage               =   image.resizeBy(width: image.size.width * (3 - repeatCount))!
                    
                    let uploadedImageData       =   NSData(data: uploadedImage.jpegData(compressionQuality: 1)!)
                    uploadedImageSize           =   CGFloat(uploadedImageData.length) / 1024.0
                    
                } while (uploadedImageSize > 800.0)
                
                // API 'Posting image'
                RestAPIManager.posting(uploadedImage, imageSignature, completion: { imageURL in
                    Logger.log(message: "imageURL = \(imageURL ?? "XXX")", event: .debug)
                    
                    if let imagePath = imageURL {
                        imagesAttachments[index].markdownValue  =   String(format: "![](%@)", imagePath)
                    }
                })
            }
        }
        
        while imagesAttachments.filter({ $0.markdownValue == nil }).count > 0 { }
        
        completion(imagesAttachments)
    }
    
    func load(postPermlink: String, completion: @escaping (ErrorAPI) -> Void) {
        let content = RequestParameterAPI.Content(author: User.current!.nickName, permlink: postPermlink)
        
        RestAPIManager.loadPostPermlink(byContent: content, completion: { errorAPI in
            completion(errorAPI)
        })

    }
}
