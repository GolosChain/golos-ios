//
//  IntroViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: UI
    var scrollLabels = [UILabel]()
    
    // MARK: Module
    let presenter = IntroPresenter()
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: SetupUI
    private func setupUI() {
        title = ""
        
        configureBackButton()
        
        enterButton.setBlueButtonRoundEdges()
        registerButton.setBorderButtonRoundEdges()
        moreInfoButton.setTitleColor(UIColor.Project.buttonTextGray, for: .normal)
        
        pageControl.numberOfPages = presenter.scrollStrings.count
        
        setupScrollView()
    }
    
    private func setupScrollView() {
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
    
    
    // MARK: Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, label) in scrollLabels.enumerated() {
            let x = scrollView.bounds.size.width * CGFloat(index)
            var scrollViewBounds = scrollView.bounds
            scrollViewBounds.origin.x = x
            label.frame = scrollViewBounds
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * CGFloat(scrollLabels.count), height: scrollView.bounds.size.height)
    }
    
    
    // MARK: Actions
    @IBAction func enterButtonPressed(_ sender: Any) {
        openLoginScreen()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let moreUrl = URL.init(string: Constants.Urls.registration) else {
            Utils.showAlert(title: "Wrong registration url", message: "Developer error!")
            return
        }
        
        UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        guard let moreUrl = URL.init(string: Constants.Urls.moreInfoAbout) else {
            Utils.showAlert(title: "Wrong more info url", message: "Developer error!")
            return
        }
        
        UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
    }
    
    
    // MARK: Navigation
    func openLoginScreen() {
        let loginViewController = LoginViewController.nibInstance()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}


// MARK: UIScrollViewDelegate
extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.bounds.size.width
        let pageNumber = scrollView.contentOffset.x / scrollViewWidth
        pageControl.currentPage = Int(pageNumber)
        print(scrollView.contentOffset.x / scrollViewWidth)
        print(scrollView.contentOffset)
    }
}
