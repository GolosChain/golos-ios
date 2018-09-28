//
//  PostShowTagCollectionViewCell.swift
//  Golos
//
//  Created by msm72 on 02.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class PostShowTagCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var completionButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var tagButton: UIButton! {
        didSet {
            tagButton.tune(withTitle:       "",
                           hexColors:       [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                           font:            UIFont(name: "SFProDisplay-Medium", size: 12.0),
                           alignment:       .center)
            
            tagButton.setBorder(color: UIColor(hexString: "#e0e0e0").cgColor, cornerRadius: 30.0 * heightRatio / 2)
        }
    }
    

    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Actions
    @IBAction func tagButtonTapped(_ sender: UIButton) {
        sender.setBorder(color: UIColor(hexString: "#e0e0e0").cgColor, cornerRadius: sender.bounds.height / 2)

        self.completionButtonTapped!()
    }
    
    @IBAction func tagButtonTappedDown(_ sender: UIButton) {
        sender.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: sender.bounds.height / 2)
    }
}


// MARK: - ConfigureCell
extension PostShowTagCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        if var title = item as? String {
            title = title.transliteration(forPermlink: false)
            
            self.tagButton.setTitle(title.uppercaseFirst, for: .normal)
        }
    }
}
