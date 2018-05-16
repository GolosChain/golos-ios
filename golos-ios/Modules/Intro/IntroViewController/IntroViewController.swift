//
//  IntroViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class IntroViewController: UIViewController {
    // MARK: - Properties
    var scrollLabels = [UILabel]()
    let presenter = IntroPresenter()

    
    // MARK: - IBOutlets
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Success", event: .severe)

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.log(message: "Success", event: .severe)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.log(message: "Success", event: .severe)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Custom Functions
    private func setupUI() {
        Logger.log(message: "Success", event: .severe)

        title = ""
        configureBackButton()
        enterButton.setBlueButtonRoundEdges()
        registerButton.setBorderButtonRoundEdges()
        moreInfoButton.setTitleColor(UIColor.Project.buttonTextGray, for: .normal)
        
        pageControl.numberOfPages = presenter.scrollStrings.count
        
        setupScrollView()
    }
    
    private func setupScrollView() {
        Logger.log(message: "Success", event: .severe)

        scrollView.delegate = self
        let strings = presenter.scrollStrings
        
        for string in strings {
            let label = UILabel()
            label.font = Fonts.shared.regular(with: 16.0)
            label.textColor = UIColor.Project.textBlack
            label.text = string
            label.numberOfLines = 0
            label.textAlignment = .center
            scrollView.addSubview(label)
            scrollLabels.append(label)
        }
    }
    
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.log(message: "Success", event: .severe)

        for (index, label) in scrollLabels.enumerated() {
            let pointX = scrollView.bounds.size.width * CGFloat(index)
            var scrollViewBounds = scrollView.bounds
            scrollViewBounds.origin.x = pointX
            label.frame = scrollViewBounds
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * CGFloat(scrollLabels.count), height: scrollView.bounds.size.height)
    }
    
    
    // MARK: - Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        Logger.log(message: "Success", event: .severe)

        openLoginScreen()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        Logger.log(message: "Success", event: .severe)

        guard let moreUrl = URL.init(string: ConstantsApp.Urls.registration) else {
            Utils.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        Logger.log(message: "Success", event: .severe)

        guard let moreUrl = URL.init(string: ConstantsApp.Urls.moreInfoAbout) else {
            Utils.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
    }
    
    
    // MARK: - Navigation
    func openLoginScreen() {
        Logger.log(message: "Success", event: .severe)

        let loginViewController = LoginViewController.nibInstance()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}


// MARK: - UIScrollViewDelegate
extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.bounds.size.width
        let pageNumber = scrollView.contentOffset.x / scrollViewWidth
        
        pageControl.currentPage = Int(pageNumber)
        
        Logger.log(message: "\(scrollView.contentOffset.x / scrollViewWidth)", event: .verbose)
        Logger.log(message: "\(scrollView.contentOffset)", event: .verbose)
    }
}
