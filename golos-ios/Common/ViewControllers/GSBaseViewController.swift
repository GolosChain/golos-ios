//
//  BaseViewController.swift
//  ViewTest
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SafariServices

class GSBaseViewController: UIViewController {
    // MARK: - Properties
    var foregroundRemoteNotificationView: ForegroundRemoteNotificationView?
    

    // MARK: - Custom Functions
    @objc func localizeTitles() {}

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func displayLocalNotification() {
        if let subview = self.foregroundRemoteNotificationView, !subview.isDisplay {
            self.view.addSubview(subview)

            UIView.animate(withDuration: 0.5,
                           animations: {
                            subview.frame.origin.y = 0.0
                            (UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow)?.alpha = 0.0
            },
                           completion: { success in
                            if success {
                                subview.isDisplay = true

                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.5) {
                                    self.hide(localNotification: subview)
                                }
                            }
            })
        }
    }
    
    func hide(localNotification: ForegroundRemoteNotificationView) {
        if let subview = self.foregroundRemoteNotificationView, subview.isDisplay, subview === localNotification {
            UIView.animate(withDuration: 0.5,
                           animations: {
                            subview.frame.origin.y = -100.0
                            (UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow)?.alpha = 1.0
            },
                           completion: { success in
                            if success {
                                subview.isDisplay = false
                                subview.removeFromSuperview()
                                self.foregroundRemoteNotificationView = nil
                            }
            })
        }
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar(withBackButtonTitle title: String? = nil) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.configureBackButton(withTitle: title)
    }
    
    private func configureBackButton(withTitle title: String? = nil) {
        let backImage = UIImage(named: "icon-button-back-black-normal")
        
        self.navigationController?.navigationBar.backIndicatorImage                 =   backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage   =   backImage
        
        self.navigationItem.backBarButtonItem   =   UIBarButtonItem(title:      title == nil ? "" : title!.localized(),
                                                                    style:      .plain,
                                                                    target:     nil,
                                                                    action:     nil)
    }

    func showAlertView(withTitle title: String, andMessage message: String, attributedText: NSMutableAttributedString? = nil, actionTitle: String? = "Enter Title", needCancel cancel: Bool, isCancelLeft: Bool = true, completion: @escaping ((Bool) -> Void)) {
        let alertViewController = UIAlertController.init(title: title.localized(), message: message.localized(), preferredStyle: .alert)

        if let attrText = attributedText {
            alertViewController.setValue(attrText, forKey: "attributedMessage")
        }
        
        let alertViewControllerCancelAction = UIAlertAction.init(title: "ActionCancel".localized(), style: .destructive, handler: { _ in
            return completion(false)
        })

        let alertViewControllerOkAction = UIAlertAction.init(title: (cancel ? actionTitle!.localized() : "ActionOk".localized()), style: .default, handler: { _ in
            return completion(true)
        })
        
        if cancel {
            if isCancelLeft {
                alertViewController.addAction(alertViewControllerCancelAction)
                alertViewController.addAction(alertViewControllerOkAction)
            } else {
                alertViewController.addAction(alertViewControllerOkAction)
                alertViewController.addAction(alertViewControllerCancelAction)
            }
        } else {
            alertViewController.addAction(alertViewControllerOkAction)
        }

        alertViewController.show()
    }
    
    func isCurrentOperationPossible() -> Bool {
        guard !User.isAnonymous else {
            self.showAlertView(withTitle: "Enter Title", andMessage: "Please Login in App", needCancel: true, completion: { success in
                if success {
                    NotificationCenter.default.post(name:       NSNotification.Name.appStateChanged,
                                                    object:     nil,
                                                    userInfo:   nil)
                }
            })
            
            return false
        }
        
        return true
    }
    
    func openExternalLink(byURL url: String) {
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            
            return
        }
        
        guard let pageURL = URL.init(string: url) else {
            self.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        let safari = SFSafariViewController(url: pageURL)
        self.present(safari, animated: true, completion: nil)
    }
    
    func displayAlertView(byDislike isDislike: Bool) -> NSMutableAttributedString {
        let fullAttributedString = NSMutableAttributedString()
        
        if isDislike {
            let text1       =   "Voice Power Label 2".localized()
            let text2       =   "Voice Power Label 3".localized()
            let text3       =   "Voice Power Label 4".localized()
            let subtitle    =   "Voice Power Subtitle".localized()
            
            let strings     =   [subtitle, text1, text2, text3]
            
            // Set Subtitle
            for (index, string) in strings.enumerated() {
                let bulletPoint         =   "\u{2022}"
                let formattedString     =   index == 0 ? "\n\(string)\n" : "\(bulletPoint) \(string)\n"
                let attributedString    =   NSMutableAttributedString(string: formattedString)
                
                var paragraphStyle: NSMutableParagraphStyle
                
                paragraphStyle          =   NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                paragraphStyle.tabStops =   [NSTextTab(textAlignment: .left, location: 20, options: [NSTextTab.OptionKey: Any]())]
                
                paragraphStyle.headIndent           =   index == 0 ? 5 : 15
                paragraphStyle.lineSpacing          =   1.4
                paragraphStyle.defaultTabInterval   =   20
                paragraphStyle.firstLineHeadIndent  =   5
                
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(.font, value: UIFont(name: "SFProDisplay-Regular", size: 14.0)!, range: NSRange(location: 0, length: attributedString.length))
                
                fullAttributedString.append(attributedString)
            }
        }
            
        else {
            let subtitle    =   "Cancel Vote Message".localized()
            
            
            // Set Subtitle
            let formattedString     =   "\n\(subtitle)\n"
            let attributedString    =   NSMutableAttributedString(string: formattedString)
            
            var paragraphStyle: NSMutableParagraphStyle
            
            paragraphStyle          =   NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.tabStops =   [NSTextTab(textAlignment: .left, location: 20, options: [NSTextTab.OptionKey: Any]())]
            
            paragraphStyle.headIndent           =   5
            paragraphStyle.lineSpacing          =   1.4
            paragraphStyle.defaultTabInterval   =   20
            paragraphStyle.firstLineHeadIndent  =   5
            
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.font, value: UIFont(name: "SFProDisplay-Regular", size: 14.0)!, range: NSRange(location: 0, length: attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        
        return fullAttributedString
    }

    
    // MARK: - Actions
    @objc func adjustForKeyboard(notification: Notification) {
    }
}
