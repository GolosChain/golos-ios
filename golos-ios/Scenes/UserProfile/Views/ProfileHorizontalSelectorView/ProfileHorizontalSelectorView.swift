//
//  ProfileHorizontalSelectorView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileHorizontalSelectorViewDelegate: class {
    func didSelectItem(at index: Int)
}

struct ProfileHorizontalSelectorItem {
    let title: String
}

class ProfileHorizontalSelectorView: PassthroughView {
    // MARK: - Constants
    private let selectionViewHeight: CGFloat = 2.0
    
    
    // MARK: - Properties
    let selectionView = UIView()
    var selectedButton: UIButton?

    
    // MARK: - Delegate
    weak var delegate: ProfileHorizontalSelectorViewDelegate?


    // MARK: - IBOutlets
    @IBOutlet weak var postsButton: UIButton!
    @IBOutlet weak var answersButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet var actionButtonsCollection: [UIButton]! {
        didSet {
            _ = actionButtonsCollection.map({
                $0.titleLabel?.font             =   UIFont(name: "SFProDisplay-Regular", size: 13.0 * widthRatio)!
                $0.titleLabel?.textAlignment    =   .center
                $0.setTitle($0.titleLabel?.text?.localized(), for: .normal)
                $0.theme_setTitleColor(darkGrayWhiteColorPickers, forState: .normal)
                $0.theme_setTitleColor(blackWhiteColorPickers, forState: .highlighted)
                $0.theme_setTitleColor(blackWhiteColorPickers, forState: .selected)
                $0.setProfileHeaderButton()
            })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let selectedButton = selectedButton else { return }
        
        moveSelectionView(to: selectedButton, animated: false)
    }
    

    // MARK: - Custom Functions
    private func commonInit() {
        let nib = UINib(nibName: String(describing: ProfileHorizontalSelectorView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints                  =   false
        view.topAnchor.constraint(equalTo: topAnchor).isActive          =   true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive      =   true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive        =   true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    =   true
        
        setupUI()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        selectionView.backgroundColor = UIColor.Project.profileSelectionViewBackground
       
        let frame = CGRect(x:       postsButton.frame.origin.x,
                           y:       bounds.size.height - selectionViewHeight,
                           width:   postsButton.frame.width,
                           height:  selectionViewHeight)
        
        selectionView.frame = frame
        addSubview(selectionView)
        
        postsButton.isSelected  =   true
        selectedButton          =   postsButton
        
        add(shadow: true, onside: .bottom)
    }
    
    private func moveSelectionView(to button: UIButton, progress: CGFloat = 1, animated: Bool) {
        var frame               =   selectionView.frame
        
        frame.origin.x          =   button.frame.origin.x
        frame.size.width        =   button.frame.size.width
        frame.origin.y          =   bounds.size.height - selectionViewHeight
        
        let animation = {
            self.selectionView.frame = frame
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: animation, completion: nil)
        }
        
        else {
            animation()
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerActionButtonTapped(_ sender: UIButton) {
        guard sender != selectedButton else {
            return
        }
        
        actionButtonsCollection.forEach {$0.isSelected = $0 == sender}
        selectedButton = sender
        moveSelectionView(to: sender, animated: true)
        
        guard let buttonIndex = actionButtonsCollection.index(of: sender) else {
            return
        }
        
        delegate?.didSelectItem(at: buttonIndex)
    }
    
    
    // MARK: - Scrolling
    func changeSelectedButton(at index: Int, progress: CGFloat = 0) {
        let button = actionButtonsCollection[index]
        moveSelectionView(to: button, progress: progress, animated: true)
        selectedButton = button
        actionButtonsCollection.forEach { $0.isSelected = $0 == button }
    }
}
