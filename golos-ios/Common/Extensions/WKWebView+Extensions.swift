//
//  WKWebView+Extensions.swift
//  Golos
//
//  Created by msm72 on 12/4/18.
//  Copyright © 2018 golos. All rights reserved.
//

import WebKit
import GoloSwift
import Foundation

extension WKWebView {
    func setBackgroundColor(forAppTheme isAppThemeDark: Bool) {
        let css     =   isAppThemeDark ? "body { background-color: #393636; color: #FFFFFF }" : "body { background-color: #FFFFFF; color: #333333 }"
        let js      =   "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        self.evaluateJavaScript(js, completionHandler: nil)
    }
}
