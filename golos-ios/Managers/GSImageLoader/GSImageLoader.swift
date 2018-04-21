//
//  GSImageLoader.swift
//  GSImageLoader
//
//  Created by Grigory on 17/02/2018.
//  Copyright © 2018 Golos. All rights reserved.
//

import UIKit

class GSImageLoader {
    // MARK: - Properties
    let cache = PINCache.shared()
    let operationQueue = OperationQueue()
    
    
    // MARK: - Custom Functions
    func startLoadImage(with urlString: String, resize: CGSize? = .zero, completion: @escaping (UIImage?) -> Void) {
        let csCopy = CharacterSet(bitmapRepresentation: CharacterSet.urlPathAllowed.bitmapRepresentation)
        
        guard let correctedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: csCopy) else {
            return
        }
        
        guard let url = URL(string: correctedUrlString) else {
            return
        }
        
        if let cacheImage = cache.object(forKey: correctedUrlString) as? UIImage {
            completion(cacheImage)
            return
        }        
        
        let imageOperation = GSImageLoadOperation(with: url)
       
        imageOperation.completionBlock = {
            if let image = imageOperation.image {
                PINCache.shared().setObject(image, forKey: correctedUrlString)
            }
        
            DispatchQueue.main.async {
                completion(imageOperation.image)
            }
        }
        
        operationQueue.addOperations([imageOperation], waitUntilFinished: false)
    }
    
    func stopLoadImage(with urlString: String) {
        guard URL(string: urlString) != nil else {
            return
        }
        
        let operation = operationQueue.operations.first { operation -> Bool in
            guard let operation = operation as? GSImageLoadOperation else { return false }
            return operation.imageUrl.absoluteString == urlString
        }
        
        operation?.cancel()
    }
}
