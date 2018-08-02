//
//  AddTagCollectionViewCell.swift
//  golos-ios
//
//  Created by msm72 on 18.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class AddTagCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var completionAddNewTag: (() -> Void)?
    var completionAddButtonChangeFrame: ((CGRect) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.frame.size = CGSize(width: 36.0 * widthRatio, height: 30.0 * heightRatio)
            addButton.layer.cornerRadius = addButton.frame.height / 2
        }
    }
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.completionAddNewTag!()
    }
}
