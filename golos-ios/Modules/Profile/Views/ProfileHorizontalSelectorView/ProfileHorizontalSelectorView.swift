//
//  ProfileHorizontalSelectorView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileHorizontalSelectorViewDelegate: class {
    func didSelect(profileFeedType: ProfileFeedType)
}

class ProfileHorizontalSelectorView: UIView {
    
    //MARK: Constants
    private let selectionViewHeight: CGFloat = 2.0
    
    //MARK: Outlets properties
    @IBOutlet weak var postsButton: UIButton!
    @IBOutlet weak var answersButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    
    //MARK: UI Properties
    let selectionView = UIView()
    
    
    //MARK: Delegate
    weak var delegate: ProfileHorizontalSelectorViewDelegate?
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: String(describing: ProfileHorizontalSelectorView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupUI()
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        selectionView.backgroundColor = UIColor.Project.profileSelectionViewBackground
        let frame = CGRect(x: postsButton.frame.origin.x,
                           y: bounds.size.height - selectionViewHeight,
                           width: postsButton.frame.width,
                           height: selectionViewHeight)
        selectionView.frame = frame
        addSubview(selectionView)
        
        postsButton.setTitleColor(UIColor.Project.textPlaceholderGray, for: .normal)
        postsButton.setTitleColor(UIColor.Project.textBlack, for: .highlighted)
        postsButton.setTitleColor(UIColor.Project.textBlack, for: .selected)
        
        answersButton.setTitleColor(UIColor.Project.textPlaceholderGray, for: .normal)
        answersButton.setTitleColor(UIColor.Project.textBlack, for: .highlighted)
        answersButton.setTitleColor(UIColor.Project.textBlack, for: .selected)
        
        favoriteButton.setTitleColor(UIColor.Project.textPlaceholderGray, for: .normal)
        favoriteButton.setTitleColor(UIColor.Project.textBlack, for: .highlighted)
        favoriteButton.setTitleColor(UIColor.Project.textBlack, for: .selected)
        
        postsButton.isSelected = true
    }
    
    private func moveSelectionView(to button: UIButton) {
        var frame = selectionView.frame
        frame.origin.x = button.frame.origin.x
        frame.size.width = button.frame.size.width
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.selectionView.frame = frame
        }) { _ in }
    }
    
    
    //MARK: Actions
    @IBAction func didPressButton(_ sender: UIButton) {
        buttons.forEach{$0.isSelected = $0 == sender}
        moveSelectionView(to: sender)
        switch sender {
        case postsButton:
            delegate?.didSelect(profileFeedType: .posts)
        case answersButton:
            delegate?.didSelect(profileFeedType: .answers)
        case favoriteButton:
            delegate?.didSelect(profileFeedType: .favorite)
        default:
            break
        }
    }
}
