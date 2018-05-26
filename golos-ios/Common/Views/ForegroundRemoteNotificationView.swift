//
//  ForegroundRemoteNotificationView.swift
//  Golos
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import LayoutKit

class ForegroundRemoteNotificationView: UIView {
    // MARK: - Properties
    var isDisplay: Bool = false
    private var handlerCancelButtonTapped: (() -> Void)?
    private let tapRecognizer = UITapGestureRecognizer()

    
    // MARK: - IBOutlets
    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = UIColor.white
        }
    }

    
    // MARK: - Class Initialization
    init(completionHandler: (() -> Void)?) {
        let frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 70.0 * widthRatio)
        super.init(frame: frame)
        
        isDisplay = false
        createFromXIB()
        self.setupUI()
        
        handlerCancelButtonTapped = completionHandler
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
    
    private func setupUI() {
        // UIImageView's
        let leftImage = SizeLayout<UIImageView>(width: 40.0 * widthRatio, height: 40.0 * widthRatio, config: { imageView in
            imageView.image         =   UIImage(named: "icon-article-upvote")
            imageView.contentMode   =   .scaleAspectFill
        })

        let cancelImage = SizeLayout<UIImageView>(width: 24.0 * widthRatio, height: 24.0 * widthRatio, config: { imageView in
            imageView.image         =   UIImage(named: "icon-close-button-normal")
            imageView.contentMode   =   .center
            
            // Add tap gesture
            imageView.isUserInteractionEnabled = true
            self.tapRecognizer.addTarget(self, action: #selector(self.cancelImageHasBeenTapped))
            imageView.addGestureRecognizer(self.tapRecognizer)
        })

        // UILabel's
        let titleLabel              =   LabelLayout<UILabel>(text:              "У вас осталось 30 неизрасходованных апвоутов за сегодняшний день.",
                                                             font:              UIFont.init(name: "SFProDisplay-Regular", size: 12.0 * widthRatio)!,
                                                             lineHeight:        29.0 * widthRatio,
                                                             numberOfLines:     2,
                                                             alignment:         .fill,
                                                             config: { labelTitle in
                                                                labelTitle.textColor        =   UIColor(hexString: "#333333")
        })

        let noteLabel               =   LabelLayout<UILabel>(text:              "Проголосовать за посты сейчас",
                                                             font:              UIFont.init(name: "SFProDisplay-Regular", size: 12.0 * widthRatio)!,
                                                             lineHeight:        15.0 * widthRatio,
                                                             numberOfLines:     1,
                                                             alignment:         .fill,
                                                             config: { labelNote in
                                                                labelNote.textColor     =   UIColor(hexString: "#333333")
        })
        
        // Slack's
        let stackLabels             =   StackLayout(
                                            axis:           .vertical,
                                            spacing:        4.0 * widthRatio,
                                            alignment:      .fill,
                                            sublayouts:     [titleLabel, noteLabel]
                                        )
        
        let leftStack               =   StackLayout(
                                            axis:           .horizontal,
                                            spacing:        20.0 * widthRatio,
                                            sublayouts:     [leftImage, stackLabels]
                                        )

        let mainStack               =   StackLayout(
                                            axis:           .horizontal,
                                            spacing:        8.0 * widthRatio,
                                            sublayouts:     [leftStack, cancelImage]
                                        )

        let insets                  =   UIEdgeInsets(top: 12.0 * widthRatio, left: 16.0 * widthRatio, bottom: 10.0 * widthRatio, right: 21.0 * widthRatio)
        let notificationLayout      =   InsetLayout(insets: insets, sublayout: mainStack)
        
        notificationLayout.arrangement(width: view.frame.width).makeViews(in: self)
    }
    
    @objc private func cancelImageHasBeenTapped() {
        self.handlerCancelButtonTapped!()
    }
}
