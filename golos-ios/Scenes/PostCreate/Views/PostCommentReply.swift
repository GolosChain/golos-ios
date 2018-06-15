//
//  PostCommentReply.swift
//  Golos
//
//  Created by msm72 on 14.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import SwiftTheme

class PostCommentReply: UIView {
    // MARK: - IBOutlets
    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.tune()
        }
    }

    @IBOutlet weak var commentLabel: UILabel! {
        didSet {
            commentLabel.tune(withText:             "Вот так выглядит женская половина (а по факту пятая часть) команды проекта 50/50.",
                              hexColors:            darkGrayWhiteColorPickers,
                              font:                 UIFont(name: "SFUIDisplay-Regular", size: 13.0 * widthRatio),
                              alignment:            .left,
                              isMultiLines:         true)
            
            commentLabel.numberOfLines = 2
        }
    }
    
    
    // MARK: - Class Initialization
    init(withThemeName name: String?) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 375.0 * widthRatio, height: 70.0 * heightRatio)))
        
        createFromXIB()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    func createFromXIB() {
        UINib(nibName: String(describing: PostCommentReply.self), bundle: Bundle(for: PostCommentReply.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
}
