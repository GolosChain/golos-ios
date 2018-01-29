//
//  TagCollectionViewCell.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagButton: TagTokenButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func getSize(with string: String) -> CGSize {
        return CGSize(width: string.width(with: Fonts.shared.medium(with: 12.0), height: 25.0), height: 25.0)
    }

}
