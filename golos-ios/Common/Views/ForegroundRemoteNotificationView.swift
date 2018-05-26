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
        let frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 70.0 * heightRatio)
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
        self.frame.origin.y = -100.0
    }
}
