//
//  NavigationDropDownView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class NavigationDropDownView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    
    // MARK: - Custom Functions
    func commonInit() {
        let nib = UINib(nibName: String(describing: NavigationDropDownView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    // MARK: - Actions
    @IBAction func didPressTitleButton(_ sender: Any) {
        rotateArrow()
    }
    
    
    // MARK: - UI
    private func rotateArrow() {
        UIView.animate(withDuration: 0.3, animations: {
            self.arrowImage.transform = self.arrowImage.transform.rotated(by: 180 * CGFloat(Double.pi/180))
        })
    }
    
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
}
