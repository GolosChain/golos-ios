//
//  GSImageLoadOperation.swift
//  GSImageLoader
//
//  Created by Grigory on 17/02/2018.
//  Copyright © 2018 Golos. All rights reserved.
//

import UIKit

class GSImageLoadOperation: GSOperation {
    private(set) public var imageUrl: URL
    
    var error: NSError?
    var image: UIImage?
    
    init(with imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        executing(true)
        
        URLSession.shared.dataTask(with: self.imageUrl) { [weak self] data, _, error in
            guard let strongSelf = self else { return }
            guard let data = data, error == nil else {
                strongSelf.error = error! as NSError
                strongSelf.executing(false)
                strongSelf.finish(true)
                return
            }
            
            let image = UIImage(data: data)
            strongSelf.image = image
            
            strongSelf.executing(false)
            strongSelf.finish(true)
        }.resume()
    }
}
