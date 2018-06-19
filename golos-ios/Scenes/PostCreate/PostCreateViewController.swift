//
//  PostCreateViewController.swift
//  golos-ios
//
//  Created by msm72 on 11.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift
import IQKeyboardManagerSwift

enum SceneType: Int {
    case create = 0
    case comment
    case reply
}

// MARK: - Input & Output protocols
protocol PostCreateDisplayLogic: class {
    func displayPostCreate(fromViewModel viewModel: PostCreateModels.Something.ViewModel)
    func displayPostComment(fromViewModel viewModel: PostCreateModels.Something.ViewModel)
    func displayPostCommentReply(fromViewModel viewModel: PostCreateModels.Something.ViewModel)
}

class PostCreateViewController: BaseViewController {
    // MARK: - Properties
    var isKeyboardShow = false
    
    var sceneType: SceneType = .create {
        didSet {
            self.navigationItem.title           =   (sceneType == .create) ? "Publish Title".localized() : "Comment Title".localized()
            stackViewTopConstraint.constant     =   (sceneType == .comment) ? -70.0 * widthRatio : 0.0
            
            _ = sceneViewsCollection.map({ $0.isHidden = ($0.tag == sceneType.rawValue) ? false : true })
            
            if sceneType == .reply {
//                self.commentReplyView.commentLabel.text = self.router?.dataStore?.commentText
            }
        }
    }
    
    var interactor: PostCreateBusinessLogic?
    var router: (NSObjectProtocol & PostCreateRoutingLogic & PostCreateDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var commentReplyView: PostCommentReply! {
        didSet {
        }
    }
    
    @IBOutlet weak var tagsTitleLabel: UILabel! {
        didSet {
            tagsTitleLabel.tune(withText:           "Add Max 5 Tags",
                                hexColors:          darkGrayWhiteColorPickers,
                                font:               UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio),
                                alignment:          .left,
                                isMultiLines:       false)
        }
    }
    
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.contentInset    =   UIEdgeInsets(top: 0.0, left: -4.0, bottom: 8.0, right: 0.0)
            contentTextView.delegate        =   self
        }
    }
    
    @IBOutlet var sceneViewsCollection: [UIView]!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            containerViewHeightConstraint.constant = 48.0 * heightRatio
        }
    }
    
    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   PostCreateInteractor()
        let presenter               =   PostCreatePresenter()
        let router                  =   PostCreateRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routeToTagsViewControllerWithSegue" {
            let tagsVC = segue.destination  as! TagsCollectionViewController
            
            // Handler change frame
            tagsVC.complationCollectionViewChangeHeight = { [weak self] height in
                self?.containerViewHeightConstraint.constant = height
            }
            
            // Handler start editing tags
            tagsVC.completionStartEndEditing = { [weak self] constant in
                self?.tagsViewBottomConstraint.constant = constant
            }
        }
        
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.log(message: "Success", event: .severe)
        
        self.setConstraint()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tune()
        
        sceneType = .comment
        
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.add(shadow: true, withBarTintColor: .white)
        self.navigationController?.hidesBarsOnTap = false
        
        // Placeholder
        contentTextView.tune(withPlaceholder:   sceneType == .create ? "Enter Text Placeholder" : "Enter Comment Placeholder",
                             textColors:        darkGrayWhiteColorPickers,
                             font:              UIFont(name: "SFUIDisplay-Regular", size: 13.0 * widthRatio),
                             alignment:         .left)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.contentTextView.text = nil
    }
    
    
    // MARK: - Custom Functions
    private func saveToAlbum(image: UIImage) {
        if let imageData = UIImageJPEGRepresentation(image, 0.6), let compressedJPGImage = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
            
            self.showAlertView(withTitle: "Info", andMessage: "Image saved to Photo Library", needCancel: false, completion: { [weak self] _ in
                self?.contentTextView.add(object: image)
            })
        }
    }
    
    private func setConstraint() {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            self.contentViewBottomConstraint.constant = (self.isKeyboardShow ? 140 : 16.0) * heightRatio
        }
        
        else {
            self.contentViewBottomConstraint.constant = (self.isKeyboardShow ? 100.0 : 16.0) * heightRatio
        }
    }
    
    
    // MARK: - Actions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        let fromView: UIView    =   self.view
        let toView: UIView      =   (self.navigationController!.tabBarController?.viewControllers?.first!.view)!
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#4469af")
                        self.navigationController?.navigationBar.isHidden = true
        }, completion: { _ in
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionCrossDissolve) { [weak self] _ in
                self?.navigationController?.tabBarController?.selectedIndex = 0
            }
        })
    }
    
    @IBAction func publishBarButtonTapped(_ sender: UIBarButtonItem) {
        switch sceneType {
        case .create:
            let postCreateRequestModel = PostCreateModels.Something.RequestModel()
            interactor?.postCreate(withRequestModel: postCreateRequestModel)

        case .comment:
            let postCommentRequestModel = PostCreateModels.Something.RequestModel()
            interactor?.postComment(withRequestModel: postCommentRequestModel)

        case .reply:
            let postCommentReplyRequestModel = PostCreateModels.Something.RequestModel()
            interactor?.postCommentReply(withRequestModel: postCommentReplyRequestModel)
        }
    }
}


// MARK: - PostCreateDisplayLogic
extension PostCreateViewController: PostCreateDisplayLogic {
    func displayPostCreate(fromViewModel viewModel: PostCreateModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
    
    func displayPostComment(fromViewModel viewModel: PostCreateModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
    
    func displayPostCommentReply(fromViewModel viewModel: PostCreateModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
}


// MARK: - UITextViewDelegate
extension PostCreateViewController: UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Text Placeholder".localized() {
            textView.text               =   nil
            textView.theme_textColor    =   blackWhiteColorPickers
        }
        
        self.isKeyboardShow             =   true
        self.setConstraint()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text               =   "Enter Text Placeholder".localized()
            textView.theme_textColor    =   darkGrayWhiteColorPickers
        }

        self.isKeyboardShow             =   false
        self.setConstraint()
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.contentTextView.showToolbar { [weak self] tag in
            textView.resignFirstResponder()
            
            switch tag {
            // Add link
            case 7:
                let linkAlert = UIAlertController(title: "Add Link Title".localized(), message: nil, preferredStyle: .alert)

                // Text
                linkAlert.addTextField { (textField) in
                    textField.placeholder = "Enter your text".localized()
                    textField.borderStyle = .none
                }

                // Link
                linkAlert.addTextField { (textField) in
                    textField.placeholder = "Enter your link".localized()
                    textField.borderStyle = .none
                }

                let actionOk = UIAlertAction(title: "ActionOk".localized(), style: .default) { [unowned linkAlert] _ in
                    guard let linkName = linkAlert.textFields![0].text, !linkName.isEmpty else {
                        return
                    }
                    
                    guard let linkAddress = linkAlert.textFields![1].text, !linkAddress.isEmpty else {
                        return
                    }
                    
                    self?.contentTextView.add(object: (linkName, linkAddress))
                }
                
                linkAlert.addAction(actionOk)
                self?.present(linkAlert, animated: true)
                
            // Add image
            case 8:
                let photoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                photoAlert.addAction(UIAlertAction(title: "Take Photo Title".localized(), style: .default, handler: { _ in
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        let imagePicker             =   UIImagePickerController()
                        imagePicker.delegate        =   self
                        imagePicker.sourceType      =   .camera
                        imagePicker.allowsEditing   =   true
                        
                        textView.resignFirstResponder()
                        
                        self?.present(imagePicker, animated: true, completion: nil)
                    }
                    
                    else {
                        self?.showAlertView(withTitle: "Error", andMessage: "Camera is not available", needCancel: false, completion: { _ in
                            self?.contentTextView.becomeFirstResponder()
                        })
                    }
                }))

                photoAlert.addAction(UIAlertAction(title: "Open Photo Title".localized(), style: .default, handler: { _ in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        let imagePicker             =   UIImagePickerController()
                        imagePicker.delegate        =   self
                        imagePicker.sourceType      =   .photoLibrary
                        imagePicker.allowsEditing   =   true
                        
                        self?.present(imagePicker, animated: true, completion: nil)
                    }
                    
                    else {
                        self?.showAlertView(withTitle: "Error", andMessage: "Album is not available", needCancel: false, completion: { _ in })
                    }
                }))
                
                photoAlert.addAction(UIAlertAction(title: "ActionCancel".localized(), style: .destructive))
                
                photoAlert.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                
                self?.present(photoAlert, animated: true)
                
            default:
                break
            }
        }
        
        return true
    }
}


// MARK: - UINavigationControllerDelegate
extension PostCreateViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.add(shadow: true, onside: .bottom)
    }
}


// MARK: - UIImagePickerControllerDelegate
extension PostCreateViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            showAlertView(withTitle: "Error", andMessage: "No image found", needCancel: false, completion: { _ in })

            return
        }

        if picker.sourceType == .camera {
            self.saveToAlbum(image: image)
        }
        
        else {
            self.contentTextView.add(object: image)
        }
    }
}
