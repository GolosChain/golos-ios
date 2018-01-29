//
//  PostedInTableViewCell.swift
//  Golos
//
//  Created by Grigory on 30/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class PostedInTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticleFooterTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}
