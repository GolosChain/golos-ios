//
//  HorizontalSelectorView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol HorizontalSelectorViewDelegate: class {
    func didChangeSelectedIndex(_ index: Int)
}

class HorizontalSelectorView: UIView {
    
    //MARK: Constants
    private let edgesOffset: CGFloat = 16.0
    private let interButtonsOffset: CGFloat = 24.0
    private let animationDuration: TimeInterval = 0.3
    private let selectionViewHeight: CGFloat = 2.0
    
    
    //MARK: UI properties
    let scrollView = UIScrollView()
    var buttons = [UIButton]()
    
    var selectedButton: UIButton?
    let selectionView = UIView()

    
    //MARK: Data properties
    var items = [HorizontalSelectorItem]() {
        didSet {
            selectedItem = items.first
            selectedIndex = 0
            
            removeAllButtons()
            addItemsButtons()
        }
    }
    
    var selectedItem: HorizontalSelectorItem?
    var selectedIndex: Int?
    
    
    //MARK: Delegate
    weak var delegate: HorizontalSelectorViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.Project.darkBlueHeader
        
        scrollView.delaysContentTouches = false
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        selectionView.backgroundColor = .white
        scrollView.addSubview(selectionView)
    }
    
    
    //MARK: Buttons
    private func addItemsButtons() {
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
        for button in buttons {
            button.removeFromSuperview()
        }
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white,
                             for: .selected)
        button.setTitleColor(UIColor.Project.unselectedButtonColor,
                             for: .normal)
        button.setTitleColor(.white,
                             for: .highlighted)
        button.setTitle(title,
                        for: .normal)
        button.titleLabel?.font = Fonts.shared.regular(with: 13.0)
        button.addTarget(self,
                         action: #selector(didPressedButton(_:)),
                         for: .touchUpInside)
        return button
    }
    
    
    //MARK: Selection view
    private func moveSelectionViewToButton(_ button: UIButton?,
                                           animated: Bool) {
        guard let button = button else {return}

        var frame = selectionView.frame
        frame.origin.x = button.frame.origin.x
        frame.size.width = button.frame.size.width
        
        let animation = {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.selectionView.frame = frame
        }
        
        if animated {
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: animation,
                       completion: nil)
        } else {
            animation()
        }
    }
    
    
    //MARK: Actions
    @objc
    private func didPressedButton(_ button: UIButton) {
        guard let selectedButtonIndex = buttons.index(of: button) else {
            return
        }
        
        buttons.forEach{$0.isSelected = $0 == button}
        let selectedItem = items[selectedButtonIndex]
        self.selectedItem = selectedItem
        self.selectedIndex = selectedButtonIndex
        
        moveSelectionViewToButton(button, animated: true)
        
        delegate?.didChangeSelectedIndex(selectedButtonIndex)
    }
    
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var scrollViewContentWidth: CGFloat = edgesOffset
        for button in buttons {
            scrollViewContentWidth += button.bounds.width
        }
        
        scrollView.contentSize = CGSize(width: scrollViewContentWidth, height: self.bounds.height)
        
        var selectionFrame = selectionView.frame
        selectionFrame.size.height = selectionViewHeight
        selectionFrame.origin.y = bounds.size.height - selectionViewHeight
        selectionView.frame = selectionFrame
    }
}

struct HorizontalSelectorItem {
    let title: String
}
