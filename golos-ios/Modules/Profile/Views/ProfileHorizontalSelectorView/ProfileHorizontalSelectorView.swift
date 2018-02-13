//
//  ProfileHorizontalSelectorView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileHorizontalSelectorViewDelegate: class {
    func didSelect(profileFeedTab: ProfileFeedTab)
}

class ProfileHorizontalSelectorView: PassthroughView {
    
    // MARK: Constants
    private let selectionViewHeight: CGFloat = 2.0
    
    // MARK: Outlets properties
    @IBOutlet weak var postsButton: UIButton!
    @IBOutlet weak var answersButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    
    // MARK: UI Properties
    let selectionView = UIView()
    
    var selectedButton: UIButton?
    
    
//    var items = [ProfileHorizontalSelectorItem]()
    
    // MARK: Delegate
    weak var delegate: ProfileHorizontalSelectorViewDelegate?
    
    // MARK: Init
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
    
    
    // MARK: Setup UI
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
        selectedButton = postsButton
        addBottomShadow()
    }

    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let selectedButton = selectedButton else {
            return
        }
        moveSelectionView(to: selectedButton, animated: false)
    }
    
    
    private func moveSelectionView(to button: UIButton,
                                   progress: CGFloat = 1,
                                   animated: Bool) {
        let currentFrame = selectionView.frame
        let nextFrame = button.frame
        
        let widthDelta = (currentFrame.width - nextFrame.width) * progress
        let newWidth = currentFrame.width - widthDelta
        
        let xDelta = -(currentFrame.minX - nextFrame.minX) * progress
        let newX = currentFrame.minX + xDelta
        
        let newFrame = CGRect(x: newX, y: currentFrame.minY, width: newWidth, height: currentFrame.height)
        
        
//        frame.origin.x = button.frame.origin.x
//        frame.size.width = button.frame.size.width
//        frame.origin.y = bounds.size.height - selectionViewHeight
//
        let animation = {
            self.selectionView.frame = newFrame
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: animation, completion: nil)
        } else {
            animation()
        }
    }
    
    
    // MARK: Actions
    @IBAction func didPressButton(_ sender: UIButton) {
        guard sender != selectedButton else {
            return
        }
        buttons.forEach {$0.isSelected = $0 == sender}
        selectedButton = sender
        moveSelectionView(to: sender, animated: true)
        switch sender {
        case postsButton:
            
            delegate?.didSelect(profileFeedTab: ProfileFeedTab(type: .posts))
        case answersButton:
            delegate?.didSelect(profileFeedTab: ProfileFeedTab(type: .answers))
        case favoriteButton:
            delegate?.didSelect(profileFeedTab: ProfileFeedTab(type: .favorite))
        default:
            break
        }
    }
}

struct ProfileHorizontalSelectorItem {
    let title: String
}
