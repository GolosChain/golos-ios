//
//  IntroViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: SetupUI
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        enterButton.setBlueButtonRoundEdges()
        registerButton.setBorderButtonRoundEdges()
        moreInfoButton.setTitleColor(UIColor.Project.buttonTextGray, for: .normal)
    }
    
    //MARK: Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        Utils.inDevelopmentAlert()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        Utils.inDevelopmentAlert()
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        guard let moreUrl = URL.init(string: Constants.Urls.moreInfoAbout) else {
            Utils.showAlert(title: "Wrong more info url", message: "Developer error!")
            return
        }
        
        UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
    }
}
