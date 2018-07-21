//
//  HorizontalSelectorView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

protocol HorizontalSelectorViewDelegate: class {
    func didChangeSelectedIndex(_ index: Int, previousIndex: Int)
}

struct HorizontalSelectorItem {
    let title: String
}

class HorizontalSelectorView: UIView {
    // MARK: - Constants
    private let edgesOffset: CGFloat = 16.0
    private let interButtonsOffset: CGFloat = 24.0
    private let animationDuration: TimeInterval = 0.3
    private let selectionViewHeight: CGFloat = 2.0
    
    
    // MARK: - Properties
    weak var delegate: HorizontalSelectorViewDelegate?

    let scrollView = UIScrollView()
    var buttons = [UIButton]()
    
    var selectedButton: UIButton? {
        didSet {
            buttons.forEach { $0.isSelected = $0 == selectedButton }
        }
    }
    
    let selectionView = UIView()
    var selectedItem: HorizontalSelectorItem?
   
    var selectedIndex: Int? {
        didSet {
            guard let index = selectedIndex,
                index < buttons.count else {
                    return
            }
            
            let item = items[index]
            selectedItem = item
            
            let button = buttons[index]
            setButtonActive(button)
        }
    }

    var items = [HorizontalSelectorItem]() {
        didSet {
            selectedItem = items.first
            selectedIndex = 0
            
            removeAllButtons()
            addItemsButtons()
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        Logger.log(message: "Success", event: .severe)
        
        var scrollViewContentWidth: CGFloat = edgesOffset
        
        for button in buttons {
            scrollViewContentWidth      +=  button.bounds.width
        }
        
        scrollView.contentSize          =   CGSize(width: scrollViewContentWidth, height: 35.0 * heightRatio)
        
        var selectionFrame              =   selectionView.frame
        selectionFrame.size.height      =   selectionViewHeight
        selectionFrame.origin.y         =   scrollView.frame.height - selectionViewHeight
        selectionView.frame             =   selectionFrame
    }


    // MARK: - Custom Functions
    private func commonInit() {
        Logger.log(message: "Success", event: .severe)

        add(shadow: true, onside: .bottom)
        backgroundColor = UIColor.Project.darkBlueHeader
        
        scrollView.delaysContentTouches = false
        addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints                                =   false
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive                      =   true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive                    =   true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive                  =   true
        scrollView.heightAnchor.constraint(equalToConstant: 35.0 * heightRatio).isActive    =   true
        
        selectionView.backgroundColor = .white
        scrollView.addSubview(selectionView)
    }
    
    private func addItemsButtons() {
        Logger.log(message: "Success", event: .severe)

        var originX: CGFloat = edgesOffset

        for item in items {
            let button = createButton(with: item.title)
            button.sizeToFit()
            
            var buttonFrame = button.frame
            buttonFrame.origin.x = originX
            originX += (buttonFrame.width + interButtonsOffset)
            button.frame = buttonFrame
            
            buttons.append(button)
            scrollView.addSubview(button)
        }
        
        selectedButton = buttons.first
        moveSelectionViewToButton(selectedButton, animated: false)
    }
    
    private func removeAllButtons() {
        Logger.log(message: "Success", event: .severe)

        for button in buttons {
            button.removeFromSuperview()
        }
    }
    
    private func createButton(with title: String) -> UIButton {
        Logger.log(message: "Success", event: .severe)

        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(UIColor.Project.unselectedButtonColor, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 13.0 * widthRatio)
        button.addTarget(self, action: #selector(didPressedButton(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func setButtonActive(_ button: UIButton) {
        Logger.log(message: "Success", event: .severe)

        buttons.forEach { $0.isSelected = $0 == button }
        moveSelectionViewToButton(button, animated: true)
    }
    
    private func moveSelectionViewToButton(_ button: UIButton?, animated: Bool) {
        Logger.log(message: "Success", event: .severe)
        
        guard let button = button else {return}

        var frame = selectionView.frame
        frame.origin.x = button.frame.origin.x
        frame.size.width = button.frame.size.width
        
        let animation = { [weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.selectionView.frame = frame
        }
        
        if animated {
            UIView.animate(withDuration:    animationDuration,
                           delay:           0,
                           options:         .curveEaseInOut,
                           animations:      animation,
                           completion:      nil)
        }
        
        else {
            animation()
        }
    }
    
    
    // MARK: - Actions
    @objc private func didPressedButton(_ button: UIButton) {
        Logger.log(message: "Success", event: .severe)
        
        guard let selectedButtonIndex = buttons.index(of: button) else {
            return
        }
        
        guard let previousIndex = selectedIndex, previousIndex != selectedButtonIndex else { return }
        
        let selectedItem    =   items[selectedButtonIndex]
        self.selectedItem   =   selectedItem
        self.selectedIndex  =   selectedButtonIndex
        
        self.setButtonActive(button)
        
        delegate?.didChangeSelectedIndex(selectedButtonIndex, previousIndex: previousIndex)
    }
}
