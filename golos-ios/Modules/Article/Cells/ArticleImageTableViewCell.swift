//
//  ArticleImageTableViewCell.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleImageTableViewCell: UITableViewCell {
    
    var imageUrlString: String?

    @IBOutlet private weak var articleImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticleImageTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}
