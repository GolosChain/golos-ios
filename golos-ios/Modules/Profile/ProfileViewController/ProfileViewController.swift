//
//  ProfileViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let presenter = ProfilePresenter()

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        title = "Профиль"
    }
    
    
    //MARK: Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        presenter.logout()
    }
    
}
