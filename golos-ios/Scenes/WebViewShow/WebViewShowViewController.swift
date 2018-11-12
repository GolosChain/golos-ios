//
//  WebViewShowViewController.swift
//  Golos
//
//  Created by msm72 on 11/12/18.
//  Copyright © 2018 golos. All rights reserved.
//
//  https://www.hackingwithswift.com/read/4/1/setting-up
//

import UIKit
import WebKit
import GoloSwift

class WebViewShowViewController: GSBaseViewController {
    // MARK: - Properties
    var url: URL!
    var webView: WKWebView!
    var requestURL: URL?
    
    var currentWebViewEvent: AmplitudeEvent? {
        didSet {
            // Amplitude SDK
            if oldValue != nil {
                self.sendAmplitude(event: oldValue!, actionName: "1_close")
            }
            
            self.sendAmplitude(event: self.currentWebViewEvent!, actionName: "1_open")
        }
    }
    
    // MARK: - Class Functions
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView(frame: self.view.frame, configuration: WKWebViewConfiguration())
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if url != nil {
            self.webView.load(URLRequest(url: url))
        }
        
        self.showNavigationBar()
        self.title = "Registration".localized()
    }
}


// MARK: - WKNavigationDelegate
extension WebViewShowViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, url.absoluteString.hasPrefix("https://") else {
            decisionHandler(.allow)
            return
        }
        
        self.requestURL = url
        Logger.log(message: "requestURL = \(self.requestURL!)", event: .debug)
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch self.requestURL {
        case let url where url!.absoluteString.hasPrefix("https://reg."):
            self.currentWebViewEvent = .registration

        default:
            break
        }
    }
}
