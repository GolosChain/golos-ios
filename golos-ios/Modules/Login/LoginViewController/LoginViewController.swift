//
//  LoginViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var notRegisteredLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var changeKeyTypeButton: UIButton!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Module
    lazy var presenter: LoginPresenter = {
        let presenter = LoginPresenter()
        presenter.view = self
        return presenter
    }()
    
    var loginType: LoginType {
        get {
            return presenter.loginType
        }
        set {
            presenter.loginType = newValue
        }
    }
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loginTextField.text = nil
        loginTextField.resignFirstResponder()
        keyTextField.text = nil
        keyTextField.resignFirstResponder()
    }
    
    
    // MARK: SetupUI
    private func setupUI() {
        
        refreshLabelContent()
        
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
        
        loginTextField.delegate = self
        keyTextField.delegate = self
    }
    
    private func refreshLabelContent() {
        title = presenter.loginUIStrings.titleString
        keyTextField.placeholder = presenter.loginUIStrings.keyPlaceholder
        changeKeyTypeButton.setTitle(presenter.loginUIStrings.loginTypeString, for: .normal)
    }
    
    func startLogin() {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        enterButton.alpha = 0.7
    }
    
    func stopLogin() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        enterButton.alpha = 1
    }
    
    
    // MARK: Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        presenter.login(with: loginTextField.text, key: keyTextField.text)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let moreUrl = URL.init(string: ConstantsApp.Urls.registration) else {
            Utils.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
        }
        
        else {
            UIApplication.shared.openURL(moreUrl)
        }
    }
    
    @IBAction func changeKeyTypePressed(_ sender: Any) {
        switch loginType {
        case .activeKey:
            navigationController?.popViewController(animated: true)
        case .postingKey:
            let activeLoginViewController = LoginViewController.nibInstance()
            activeLoginViewController.loginType = .activeKey
            navigationController?.pushViewController(activeLoginViewController, animated: true)
        }
    }
    
    @IBAction func scanQRButtonPressed(_ sender: Any) {
        let qrScannerViewController = QRScannerViewController.nibInstance()
        qrScannerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: qrScannerViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let loginHelpViewController = LoginHelpViewController.nibInstance()
        loginHelpViewController.modalPresentationStyle = .overCurrentContext
        present(loginHelpViewController, animated: true, completion: nil)
    }
}


// MARK: QRScannerViewControllerDelegate
extension LoginViewController: QRScannerViewControllerDelegate {
    func didScanQRCode(with value: String) {
        keyTextField.text = value
    }
}


// MARK: LoginView
extension LoginViewController: LoginView {
    func didStartLogin() {
        startLogin()
    }
    
    func didLoginSuccessed() {
        stopAllActivity()
        presenter.changeStateToLoggedIn()
    }
    
    func stopAllActivity() {
        stopLogin()
    }
}


// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            IQKeyboardManager.sharedManager().goNext()
        case keyTextField:
            presenter.login(with: loginTextField.text, key: keyTextField.text)
        default:
            break
        }
        
        return true
    }
}
