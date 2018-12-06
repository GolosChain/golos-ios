//
//  BaseViewController.swift
//  ViewTest
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import Amplitude_iOS
import SafariServices

let kCloseSafariViewControllerNotification = "kCloseSafariViewControllerNotification"

class GSBaseViewController: UIViewController {
    // MARK: - Properties
    var foregroundRemoteNotificationView: ForegroundRemoteNotificationView?
    
    var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    var isStatusBarStyleLight = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    // MARK: - Class Functions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let mainContainerVC = self.navigationController?.viewControllers.last as? MainContainerViewController else { return .default }
        
        if let activeNC = mainContainerVC.activeViewController as? UINavigationController, let lastVC = activeNC.viewControllers.last as? GSBaseViewController {
            return lastVC.isStatusBarStyleLight ? .lightContent : .default
        }
        
        else if let activeVC = mainContainerVC.activeViewController as? GSTabBarController, let nc = activeVC.viewControllers?[selectedTabBarItem] as? UINavigationController, let tabbarVC = nc.viewControllers.last as? GSBaseViewController {
            return tabbarVC.isStatusBarStyleLight ? .lightContent : .default
        }
        
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    
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
    
    func setupNavBarStyle() {
        self.navigationController?.navigationBar.theme_tintColor            =   blackWhiteColorPickers
        self.tabBarController?.tabBar.theme_barTintColor                    =   whiteVeryDarkGrayishRedPickers
        self.navigationController?.navigationBar.theme_barTintColor         =   whiteVeryDarkGrayishRedPickers
        self.navigationController?.navigationBar.theme_titleTextAttributes  =   blackWhiteDictionaryPickers
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
    
    func showNavigationBar(withBackButtonTitle title: String? = nil, backButtonImage: UIImage = UIImage(named: (AppSettings.isAppThemeDark ? "icon-button-back-white-normal" : "icon-button-back-black-normal"))!) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.add(shadow: true, withBarTintColor: .white)

        self.setupNavBarStyle()
        self.configureBackButton(withTitle: title, backButtonImage: backButtonImage)
    }
    
    private func configureBackButton(withTitle title: String? = nil, backButtonImage: UIImage) {
        self.setupNavBarStyle()

        if title == nil {
            let customBackButton                    =   UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backBarButtonTapped))
            self.navigationItem.leftBarButtonItem   =   customBackButton
        }
        
        else {
            self.navigationItem.backBarButtonItem   =   UIBarButtonItem(title:      title!.localized(),
                                                                        style:      .plain,
                                                                        target:     self,
                                                                        action:     #selector(backBarButtonTapped))
        }
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
            }
            
            else {
                alertViewController.addAction(alertViewControllerOkAction)
                alertViewController.addAction(alertViewControllerCancelAction)
            }
        }
        
        else if title != "Subscribe Noun" && title != "Unsubscribe Noun" {
            alertViewController.addAction(alertViewControllerOkAction)
        }
            
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                alertViewController.dismiss(animated: true, completion: {
                    completion(true)
                })
            }
        }

        alertViewController.show()
    }
    
    func showAlertAction(withTitle title: String, andMessage message: String, icon: UIImage? = nil, actionTitle: String? = "Enter Title", needCancel cancel: Bool, isCancelLeft: Bool = true, completion: @escaping ((Bool) -> Void)) {
        let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let attributedTitle = NSMutableAttributedString(string: title.localized())
        attributedTitle.addAttribute(.font, value: UIFont(name: "SFUIDisplay-Medium", size: 17.0)!, range: NSRange(location: 0, length: attributedTitle.length))
        alertViewController.setValue(attributedTitle, forKey: "attributedTitle")

        let attributedMessage = NSMutableAttributedString(string: String(format: "%@%@", icon == nil ? "" : "\n\n\n", message.localized()))
        attributedMessage.addAttribute(.font, value: UIFont(name: "SFUIDisplay-Light", size: 14.0)!, range: NSRange(location: 0, length: attributedMessage.length))
        
        let userNamePattern         =   "\\@\\w*\\W?\\w*\\W?\\w*"
        let userNameRegex           =   try! NSRegularExpression(pattern: userNamePattern, options: [])
        
        if let userNameMatches = userNameRegex.firstMatch(in: message.localized(), options: .withTransparentBounds, range: NSRange(location: 0, length: message.localized().count)) {
            let range = NSRange(location:  userNameMatches.range.location + 3, length:  userNameMatches.range.length)
            attributedMessage.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        }

        alertViewController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let alertViewControllerCancelAction = UIAlertAction.init(title: "ActionCancel".localized(), style: .cancel, handler: { _ in
            return completion(false)
        })
        
        let alertViewControllerOkAction = UIAlertAction.init(title: (cancel ? actionTitle!.localized() : "ActionOk".localized()), style: .destructive, handler: { _ in
            return completion(true)
        })
        
        if cancel {
            if isCancelLeft {
                alertViewController.addAction(alertViewControllerCancelAction)
                alertViewController.addAction(alertViewControllerOkAction)
            }
            
            else {
                alertViewController.addAction(alertViewControllerOkAction)
                alertViewController.addAction(alertViewControllerCancelAction)
            }
        }
        
        else {
            alertViewController.addAction(alertViewControllerOkAction)
        }

        // Add icon
        if let iconImage = icon {
            let iconView = UIImageView(frame: CGRect(origin:    CGPoint(x: self.view.frame.midX - 30.0, y: alertViewController.view.frame.minY + 38.0),
                                                     size:      CGSize(width: 50 * widthRatio, height: 50 * widthRatio)))
            iconView.image = iconImage
            iconView.layer.cornerRadius = 25.0 * widthRatio
            iconView.clipsToBounds = true
            
            alertViewController.view.addSubview(iconView)
        }
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func isCurrentOperationPossible() -> Bool {
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            
            return false
        }

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
    
    // Amlitude SDK: https://amplitude.zendesk.com/hc/en-us/articles/215562387-Appendix-Amplitude-User-Property-Definitions
    func sendAmplitude(event: AmplitudeEvent, actionName: String) {
        var eventProperties: [AnyHashable: Any] = [ UIDevice.current.identifierForVendor!.uuidString: "DEVICE_ID" ]
        
        if !actionName.contains("webview") {
            eventProperties["iOS"] = "OS"
            eventProperties["UIDevice.current.systemVersion"] = "PLATFORM"
        }
        
        if let userNickName = User.current?.nickName {
            eventProperties[userNickName] = "USER_ID"
        } else {
            eventProperties["Anonymous"] = "USER_ID"
        }

        Amplitude.instance()?.logEvent(event.rawValue + actionName, withEventProperties: eventProperties)
    }
    
    
    // MARK: - Actions
    @objc func backBarButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
    }
}


// MARK: - SFSafariViewControllerDelegate
extension GSBaseViewController: SFSafariViewControllerDelegate {
    func openExternalLink(byURL url: String) {
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            
            return
        }
        
        guard let pageURL = URL.init(string: url) else {
            self.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }

        // Registration
        if url == GolosWebPage.registration.rawValue {
            let storyboard          =   UIStoryboard(name: "WKWebViewShow", bundle: nil)
            let destinationVC       =   storyboard.instantiateViewController(withIdentifier: "WebViewShowVC") as! WebViewShowViewController
            destinationVC.url       =   URL(string: url)

            self.navigationController?.show(destinationVC, sender: nil)
        }

        else {
            let safari = SFSafariViewController(url: pageURL)
            safari.delegate = self
            self.present(safari, animated: true, completion: nil)
        }
    }
    
    @objc private func golosWebLogin(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kCloseSafariViewControllerNotification), object: nil)

        // Get the url form the Auth callback
        guard let url = notification.object as? URL else {
            return
        }
        
        // Parse url ...
        Logger.log(message: "url = \(url)", event: .debug)
        
        // then do whatever you like, for example :
        // get the code (token) from the URL
        // and do a request to get the information you need (id, name, ...)
        // Finally dismiss the Safari View Controller with:
//        self.safariVC!.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
//        Logger.log(message: "URL = \(URL)", event: .debug)
//        return [UIActivity()]
//    }

//    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
//        Logger.log(message: "URL = \(URL)", event: .debug)
//        return [UIActivity.ActivityType.print]
//    }
//    
//    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
//        Logger.log(message: "didLoadSuccessfully = \(didLoadSuccessfully)", event: .debug)
//    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        Logger.log(message: "URL = \(URL)", event: .debug)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
