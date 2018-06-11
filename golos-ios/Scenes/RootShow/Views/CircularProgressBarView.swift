//
//  CircularProgressBarView.swift
//  Golos
//
//  Created by msm72 on 03.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class CircularProgressBarView: UIView {
    // MARK: - Properties
    var endAnimationCompletion: (() -> Void)?
    private let shapeLayer = CAShapeLayer()
    

    // MARK: - Class Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.frame.size         =   CGSize.init(width: 80.0 * widthRatio * 1.3, height: 80.0 * widthRatio * 1.3)
        self.backgroundColor    =   UIColor.clear
        
        self.setupShapeLayer()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Class Functions
    private func setupShapeLayer() {
        let circularPath        =   UIBezierPath(arcCenter:     CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2),
                                                 radius:        60.0 * widthRatio,
                                                 startAngle:    -CGFloat.pi / 2,
                                                 endAngle:      2 * CGFloat.pi,
                                                 clockwise:     true)
        
        shapeLayer.path         =   circularPath.cgPath
        shapeLayer.strokeColor  =   UIColor(hexString: "#2F73B5").cgColor
        shapeLayer.lineWidth    =   4.0 * widthRatio
        shapeLayer.fillColor    =   UIColor.clear.cgColor
        shapeLayer.lineCap      =   kCALineCapRound
        shapeLayer.strokeEnd    =   0.0
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func startAnimation() {
        let basicAnimation                      =   CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.toValue                  =   1
        basicAnimation.duration                 =   (appState == .loggedOut && !isUserAnonymous) ? 3.0 : 11.0
        basicAnimation.fillMode                 =   kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion    =   false
        
        basicAnimation.delegate                 =   self
        
        shapeLayer.add(basicAnimation, forKey: "strokeEnd")
    }
    
    func endAnimation() {
        shapeLayer.removeAllAnimations()
    }
}


// MARK: - CAAnimationDelegate
extension CircularProgressBarView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.endAnimationCompletion!()
    }
}
