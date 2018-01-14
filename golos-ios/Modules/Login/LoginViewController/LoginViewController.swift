//
//  LoginViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: SetupUI
    private func setupUI() {
        title = "Войти"
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureBackButton()
    }
}
