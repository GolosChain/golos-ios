//
//  LoginViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var notRegisteredLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var changeKeyTypeButton: UIButton!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: SetupUI
    private func setupUI() {
        title = "Войти"
        configureBackButton()
        
        enterButton.setBlueButtonRoundEdges()
        cancelButton.setBorderButtonRoundEdges()
        
        registrationButton.setTitleColor(UIColor.Project.buttonBgBlue,
                                         for: .normal)
        registrationButton.titleLabel?.font = Fonts.shared.medium(with: 16.0)
        
        notRegisteredLabel.font = Fonts.shared.regular(with: 16.0)
        notRegisteredLabel.textColor = UIColor.Project.buttonTextGray
        
        changeKeyTypeButton.setTitleColor(UIColor.Project.textBlack,
                                          for: .normal)
        changeKeyTypeButton.titleLabel?.font = Fonts.shared.regular(with: 13.0)
        
        loginTextField.font = Fonts.shared.regular(with: 16.0)
        keyTextField.font = Fonts.shared.regular(with: 16.0)
    }
    
    
    //MARK: Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        Utils.inDevelopmentAlert()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        Utils.inDevelopmentAlert()
    }
    
    @IBAction func changeKeyTypePressed(_ sender: Any) {
        Utils.inDevelopmentAlert()
    }
    
    @IBAction func scanQRButtonPressed(_ sender: Any) {
        let qrScannerViewController = QRScannerViewController.nibInstance()
        qrScannerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: qrScannerViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

//MARK: QRScannerViewControllerDelegate
extension LoginViewController: QRScannerViewControllerDelegate {
    func didScanQRCode(with value: String) {
        keyTextField.text = value
    }
}
