//
//  LoginHelpViewController.swift
//  Golos
//
//  Created by Grigory on 02/03/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class LoginHelpViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.setBlueButtonRoundEdges()
        closeButton.layer.cornerRadius = 5.0
        
        mainView.addBottomShadow()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
