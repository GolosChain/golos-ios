//
//  AnswersFeedTableViewCell.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

protocol AnswersFeedTableViewCellDelegate: class {
    func didPressAnswerButton(at cell: AnswersFeedTableViewCell)
}

class AnswersFeedTableViewCell: UITableViewCell, ReusableCell {
    // MARK: - Delegate
    weak var delegate: AnswersFeedTableViewCellDelegate?

    
    // MARK: - IBOutlets
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel! {
        didSet {
            authorNameLabel.tune(withText:          "",
                                 hexColors:         darkGrayWhiteColorPickers,
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                                 alignment:         .left,
                                 isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var answerTextLabel: UILabel! {
        didSet {
            answerTextLabel.tune(withText:          "",
                                 hexColors:         veryDarkGrayWhiteColorPickers,
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 12.0 * widthRatio),
                                 alignment:         .left,
                                 isMultiLines:      false)
            
            answerTextLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var answerButton: UIButton!  {
        didSet {
            
        }
    }
    
    @IBOutlet weak var answerTypeButton: UIButton!  {
        didSet {
            
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!  {
        didSet {
            authorNameLabel.tune(withText:          "",
                                 hexColors:         darkGrayWhiteColorPickers,
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                                 alignment:         .left,
                                 isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var commentLabel: UILabel!  {
        didSet {
            authorNameLabel.tune(withText:          "Answered your".localized(),
                                 hexColors:         darkGrayWhiteColorPickers,
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                                 alignment:         .left,
                                 isMultiLines:      false)
        }
    }
    
    @IBOutlet var widthCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthCollection.map({ $0.constant *= widthRatio })
        }
    }

    @IBOutlet var heightCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightCollection.map({ $0.constant *= heightRatio })
        }
    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Class Functions
    override func layoutSubviews() {
        super.layoutSubviews()

        pictureImageView.layer.cornerRadius = pictureImageView.bounds.width / 2
    }
    

    // MARK: - Custom Functions
    private func setup() {
        pictureImageView.layer.masksToBounds = true
        
        contentView.tune()
    }
    
    func configure(with viewModel: AnswersFeedViewModel?) {
        guard let viewModel     =   viewModel else { return }
        authorNameLabel.text    =   viewModel.authorName
        answerTextLabel.text    =   viewModel.text
        timeLabel.text          =   viewModel.time

        answerTypeButton.setTitle(viewModel.type.rawValue, for: .normal)
    }
    

    // MARK: - Actions
    @IBAction func answerButtonTapped(_ sender: UIButton) {}

    @IBAction func answerTypeButtonTapped(_ sender: UIButton) {}
}
