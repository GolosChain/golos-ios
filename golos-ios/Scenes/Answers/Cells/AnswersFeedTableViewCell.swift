//
//  AnswersFeedTableViewCell.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol AnswersFeedTableViewCellDelegate: class {
    func didPressAnswerButton(at cell: AnswersFeedTableViewCell)
}

class AnswersFeedTableViewCell: UITableViewCell, ReusableCell {
    
    // MARK: Delegate
    weak var delegate: AnswersFeedTableViewCellDelegate?

    // MARK: Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var answerTypeButton: UIButton!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        pictureImageView.layer.masksToBounds = true
        
        
    }
    
    // MARK: Configure
    func configure(with viewModel: AnswersFeedViewModel?) {
        guard let viewModel = viewModel else { return }
        authorNameLabel.text = viewModel.authorName
        answerTypeButton.setTitle(viewModel.type.rawValue, for: .normal)
        answerTextLabel.text = viewModel.text
        timeLabel.text = viewModel.time
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        pictureImageView.layer.cornerRadius = pictureImageView.bounds.width / 2
    }
    
    // MARK: Actions
    @IBAction func didPressAnswerButton(_ sender: Any) {
        
    }
}
