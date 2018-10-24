//
//  UIButton+Extensions.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import SwiftTheme

extension UIButton {    
    /// Download image
    func uploadImage(byStringPath path: String, size: CGSize, createdDate: Date, fromItem: String) {
        let uploadedSize            =   CGSize(width: size.width * 3, height: size.height * 3)
        let imagePathWithProxy      =   path.trimmingCharacters(in: .whitespacesAndNewlines).addImageProxy(withSize: uploadedSize)
        let imageURL                =   URL(string: imagePathWithProxy.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        
        Logger.log(message: "imageURL = \(imageURL!)", event: .debug)
        
        let imageKey: NSString      =   imageURL!.absoluteString as NSString
        
        // Get image from NSCache
        if let cachedImage = cacheApp.object(forKey: imageKey) {
            UIView.animate(withDuration: 0.5) {
                self.setImage(cachedImage, for: .normal)
            }
        }
                
        else {
            // Download .gif
            if imagePathWithProxy.hasSuffix(".gif"), let imageGIF = UIImage.gif(url: imagePathWithProxy) {
                // Save image to NSCache
                cacheApp.setObject(imageGIF, forKey: imageKey)
                
                DispatchQueue.main.async {
                    self.setImage(imageGIF, for: .normal)
                }
            }
                
            // Download image by URL from Internet
            else if isNetworkAvailable {
                URLSession.shared.dataTask(with: imageURL!) { data, _, error in
                    guard error == nil else {
                        DispatchQueue.main.async {
                            self.setImage(UIImage(named: "icon-user-profile-image-placeholder"), for: .normal)
                        }
                        
                        return
                    }
                    
                    if let imageData = data, let downloadedImage = UIImage(data: imageData) {
                        // Save image to NSCache
                        cacheApp.setObject(downloadedImage, forKey: imageKey)
                        
                        DispatchQueue.main.async {
                            self.setImage(downloadedImage, for: .normal)
                        }
                        
                        // Save ImageCached to CoreData
                        DispatchQueue.main.async {
                            ImageCached.updateEntity(fromItem: fromItem, byDate: createdDate, andKey: imageKey as String)
                        }
                    }
                }.resume()
            }
            
            else {
                DispatchQueue.main.async {
                    self.setImage(UIImage(named: "icon-user-profile-image-placeholder"), for: .normal)
                }
            }
        }
    }


    /// hexColors: [normal, highlighted, selected, disabled]
    func tune(withTitle title: String, hexColors: [ThemeColorPicker], font: UIFont?, alignment: NSTextAlignment) {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        
        self.titleLabel?.font               =   font
        self.titleLabel?.textAlignment      =   alignment
        self.contentMode                    =   .scaleAspectFill

        self.setTitle(title.localized(), for: .normal)
        self.theme_setTitleColor(hexColors[0], forState: .normal)
        self.theme_setTitleColor(hexColors[1], forState: .highlighted)
        self.theme_setTitleColor(hexColors[2], forState: .selected)
        self.theme_setTitleColor(hexColors[3], forState: .disabled)
    }
    
    func setBlueButtonRoundEdges() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: self.frame.height / 2)

        self.titleLabel?.font       =   UIFont(name: "SFProDisplay-Regular", size: 16.0)
        self.theme_backgroundColor  =   vividBlueWhiteColorPickers
        self.theme_setTitleColor(whiteColorPickers, forState: .normal)
    }
    
    func setBlueButtonRoundCorners() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: 4.0)
        
        self.titleLabel?.font       =   UIFont(name: "SFProDisplay-Regular", size: 16.0)
        self.theme_backgroundColor  =   vividBlueWhiteColorPickers
        self.theme_setTitleColor(whiteColorPickers, forState: .normal)
    }
    
    func setBorder(color: CGColor, cornerRadius: CGFloat) {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: cornerRadius)
        
        self.layer.borderColor      =   color
        self.layer.borderWidth      =   1.0
    }
    
    func setBorderButtonRoundEdges() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: self.frame.height / 2)

        self.layer.borderColor      =   UIColor(hexString: "#DBDBDB").cgColor
        self.layer.borderWidth      =   1.0
        self.titleLabel?.font       =   UIFont(name: "SFProDisplay-Regular", size: 16.0)
        self.theme_backgroundColor  =   whiteColorPickers
        self.theme_setTitleColor(darkGrayWhiteColorPickers, forState: .normal)
    }
    
    func setProfileHeaderButton() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: 4.0)
        backgroundColor = .white
        setTitleColor(UIColor.Project.textBlack, for: .normal)
        titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12.0)
    }
    
    private func setRoundEdges(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    
    // For Like / Dislike buttons
    func startLikeVote(withSpinner spinner: UIActivityIndicatorView) {
        self.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            spinner.startAnimating()
            self.setImage(UIImage(named: isAppThemeDark ? "icon-button-active-vote-black-empty" : "icon-button-active-vote-white-empty"), for: .normal)
        }
    }
    
    func breakLikeVote(withSpinner spinner: UIActivityIndicatorView) {
        self.isEnabled = true
        spinner.stopAnimating()
    }
}
