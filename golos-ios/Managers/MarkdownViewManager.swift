//
//  MarkdownViewManager.swift
//  Golos
//
//  Created by msm72 on 09.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import MarkdownView
import WebKit

class MarkdownViewManager: MarkdownView {
    // MARK: - Properties
    var height: CGFloat = 0.0
    var indexPath: IndexPath?
    
    // Handlers
    var completionErrorAlertView: ((String) -> Void)?
    var completionCommentAuthorTapped: ((String) -> Void)?
    var completionShowSafariURL: ((URL) -> Void)?

    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        self.isScrollEnabled    =   false

//        DispatchQueue.main.async {
            self.backgroundColor = UIColor(hexString: AppSettings.isAppThemeDark ? "#393636" : "#FFFFFF")
//        }

        // Handler: display content in App
        self.onTouchLink = { [weak self] request in
            guard let url = request.url else {
                self?.completionErrorAlertView!("Broken Link Failure")
                return false
            }
            
            if url.scheme == "file", let userName = url.pathComponents.last, userName.hasPrefix("@") {
                self?.completionCommentAuthorTapped!(userName.replacingOccurrences(of: "@", with: ""))
                return true
            }
                
            else if url.scheme!.hasPrefix("http") {
                self?.completionShowSafariURL!(url)
                return false
            }
                
            else {
                self?.completionErrorAlertView!("Broken Link Failure")
                return false
            }
        }
    }
}
