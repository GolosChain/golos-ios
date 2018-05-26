//
//  ForegroundRemoteNotificationView.swift
//  Golos
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class ForegroundRemoteNotificationView: UIView {
    // MARK: - Properties
    var isDisplay: Bool = false
    
    
    // MARK: - IBOutlets
    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = UIColor.clear
        }
    }

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    // MARK: - Class Initialization
    init() {
        let frame = CGRect.init(x: 0.0, y: -100.0, width: UIScreen.main.bounds.width * widthRatio, height: 70.0 * UIScreen.main.bounds.height)
        super.init(frame: frame)
        
        isDisplay = false
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Custom Functions
    private func createFromXIB() {
        Bundle.main.loadNibNamed(String(describing: ForegroundRemoteNotificationView.self), owner: self, options: nil)
        
        guard let view = view else { return }

        addSubview(view)
        view.frame = frame
    }
    
    func display(onView superView: UIView) {
        if !isDisplay {
            superView.addSubview(self)
            
            UIView.animate(withDuration: 0.5,
                           animations: { [weak self] in
                            self?.transform = CGAffineTransform(translationX: 0.0, y: 100.0)
                },
                           completion: { [weak self] success in
                            if success {
                                self?.isDisplay = true
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                                    self?.hide()
                                }
                            }
            })
        }
    }
    
    func hide() {
        if isDisplay {
            UIView.animate(withDuration: 0.5,
                           animations: {[weak self] in
                            self?.transform = CGAffineTransform.identity
                },
                           completion: { [weak self] success in
                            if success {
                                self?.isDisplay = false
                                self?.removeFromSuperview()
                            }
            })
        }
    }
}
