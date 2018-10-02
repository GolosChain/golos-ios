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
import Localize_Swift
import SafariServices
import MobileCoreServices
import IQKeyboardManagerSwift

@objc enum SceneType: Int {
    case createPost = 0
    case createComment
    case createCommentReply
}

// MARK: - Input & Output protocols
protocol PostCreateDisplayLogic: class {
    func displayPublishItem(fromViewModel viewModel: PostCreateModels.Item.ViewModel)
}

class PostCreateViewController: GSBaseViewController {
    // MARK: - Properties
    var firstResponder: UIView!
    var isKeyboardShow = false
   
    var tagsVC: TagsCollectionViewController!
    var sceneType: SceneType = .createPost
    
    var interactor: PostCreateBusinessLogic?
    var router: (NSObjectProtocol & PostCreateRoutingLogic & PostCreateDataPassing)?
    
    // Handlers
    var handlerSuccessCreatedItem: ((Bool) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var tagsView: UIView! {
        didSet {
            tagsView.alpha = 0.0
        }
    }

    @IBOutlet weak var postingActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.postingActivityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var commentReplyView: PostCommentReply! {
        didSet {
            // Handlers
            commentReplyView.handlerMarkdownError                   =   { [weak self] errorMessage in
                self?.showAlertView(withTitle: "Error", andMessage: errorMessage, needCancel: false, completion: { _ in })
            }
            
            commentReplyView.handlerMarkdownURLTapped               =   { [weak self] url in
                if isNetworkAvailable {
                    let safari = SFSafariViewController(url: url)
                    self?.present(safari, animated: true, completion: nil)
                }
                    
                else {
                    self?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
                }
            }
            
            commentReplyView.handlerMarkdownAuthorNameTapped        =   { [weak self] authorName in
                self?.router?.routeToUserProfileScene(byUserName: authorName)
            }
        }
    }
    
    @IBOutlet weak var postCreateView: PostCreateView! {
        didSet {
            postCreateView.completionStartEditing   =   { [weak self] isEdit in
                self?.firstResponder    =   self?.postCreateView
                self?.isKeyboardShow    =   isEdit
                
                self?.setConstraint()
            }
        }
    }
    
    @IBOutlet weak var tagsTitleLabel: UILabel! {
        didSet {
            tagsTitleLabel.tune(withText:           "Add Max 5 Tags",
                                hexColors:          darkGrayWhiteColorPickers,
                                font:               UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                alignment:          .left,
                                isMultiLines:       false)
        }
    }
    
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.contentInset    =   UIEdgeInsets(top: 0.0, left: -4.0, bottom: 8.0, right: 0.0)
            contentTextView.delegate        =   self
            
            contentTextView.placeholder     =   (sceneType == .createPost ? "Enter Text Placeholder" : "Enter Comment Placeholder").localized()
            
            contentTextView.tune(textColors:    darkGrayWhiteColorPickers,
                                 font:          UIFont(name: "SFProDisplay-Regular", size: 13.0),
                                 alignment:     .left)
        }
    }
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint!
    
    // Use with keyboard hide/show
    @IBOutlet weak var tagsViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var sceneViewsCollection: [UIView]! {
        didSet {
            _ = sceneViewsCollection.map({ $0.isHidden = ($0.tag == sceneType.rawValue) ? false : true })
        }
    }
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint! {
        didSet {
            stackViewTopConstraint.constant =   (sceneType == .createComment) ? -70.0 * heightRatio : 6.0
        }
    }

    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            containerViewHeightConstraint.constant = 48.0 * heightRatio
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach({ $0.constant *= widthRatio })
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

        NotificationCenter.default.removeObserver(self)
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
            self.tagsVC = segue.destination as? TagsCollectionViewController
            
            // Handler change frame
            tagsVC.complationCollectionViewChangeHeight = { [weak self] height in
                self?.containerViewHeightConstraint.constant = height
            }
            
            // Handler start editing tags
            tagsVC.completionStartEndEditing = { [weak self] (constant, maxY) in
                self?.firstResponder        =   constant == 0.0 ? self?.view : self?.tagsVC.view
                
                // End editing
                if constant == 0.0 {
                    self?.containerViewHeightConstraint.constant = maxY! + 18.0 * heightRatio
                }
                
                self?.setConstraint()
            }
            
            // Handler change tags
            tagsVC.completionTagsChanged = { [weak self] in
                self?.interactor?.save(tags: self?.tagsVC.tags)
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
        
        // After change ThemeTagCollectionViewCell title width
        self.tagsVC.calculateCollectionViewHeight()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tune()
        IQKeyboardManager.sharedManager().enable = false
        self.navigationItem.title = (sceneType == .createPost) ? "Publish Title".localized() : "Comment Title Verb".localized()
       
        if sceneType == .createCommentReply {
            self.commentReplyView.markdownViewManager.load(markdown: self.router?.dataStore?.commentTitle ?? "")

            self.commentReplyView.markdownViewManager.onRendered = { [weak self] height in
                self?.markdownViewHeightConstraint.constant = height + 15.0 * 2 * heightRatio
                self?.stackView.layoutIfNeeded()
                self?.showContent()
            }
        } else {
            self.showContent()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(localizeTitles), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        self.showNavigationBar()
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.add(shadow: true, withBarTintColor: .white)

        self.contentTextView.layoutManager.ensureLayout(for: self.contentTextView.textContainer)
    }

    
    // MARK: - Custom Functions
    private func saveToAlbum(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.6), let compressedJPGImage = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
            
            self.showAlertView(withTitle: "Info", andMessage: "Image saved to Photo Library", needCancel: false, completion: { [weak self] _ in
                self?.contentTextView.add(object: image.upOrientationImage()!)
            })
        }
    }

    @objc private func image(path: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        print(path) // That's the path you want
    }
    
    private func setConstraint() {
        let isKeyboardShow = self.isKeyboardShow || IQKeyboardManager.sharedManager().keyboardShowing
        
        if UIApplication.shared.statusBarOrientation.isPortrait {
            self.tagsViewBottomConstraint.constant  =   isKeyboardShow ? (firstResponder == contentTextView ? 210.0 : 168.0) : (firstResponder == tagsVC.view ? 168.0 : 16.0)
        }

        else {
            self.tagsViewBottomConstraint.constant  =   isKeyboardShow ? 100.0 : 16.0
        }
    }
    
    private func isRequestAvailable() -> Bool {
        // Check text body
        if self.contentTextView.text.isEmpty {
            self.showAlertView(withTitle: "Info", andMessage: "Post Text Body Hint", needCancel: false, completion: { _ in })
            return false
        }
        
        guard sceneType == .createPost else {
            self.interactor?.save(commentBody: self.contentTextView.text!)
            return true
        }
        
        // Check title
        if (self.postCreateView.titleTextField.text?.isEmpty)! {
            self.showAlertView(withTitle: "Info", andMessage: "Create Post Title Hint", needCancel: false, completion: { _ in })
            return false
        }
        
        // Check tags
        else if self.router?.dataStore?.tags == nil || self.router?.dataStore?.tags?.first?.title == nil || (self.router?.dataStore?.tags?.first?.title?.isEmpty)!  {
            self.showAlertView(withTitle: "Info", andMessage: "Select topic", needCancel: false, completion: { _ in })
            return false
        }
        
        // Check network connection
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            return false
        }
        
        self.interactor?.save(commentBody: self.contentTextView.text!)
        self.interactor?.save(commentTitle: self.postCreateView.titleTextField.text!)
        
        return true
    }
    
    private func changeTagsTitle(withCount count: Int) {
        self.tagsTitleLabel.text = String(format: "")
    }
    
    private func clearAllEnteredValues() {
        self.isKeyboardShow                         =   false
        self.firstResponder                         =   nil
        self.contentTextView.text                   =   nil
        self.postCreateView.titleTextField.text     =   nil
        self.tagsVC.tags                            =   nil
        self.tagsVC.collectionView.reloadData()

        self.interactor?.save(tags: nil)
    }
    
    private func showContent() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tagsView.alpha         =   self.sceneType == .createPost ? 1.0 : 0.0
            self.stackView.alpha        =   1.0
            self.contentTextView.alpha  =   1.0
        })
    }
    
    private func loadMessage() -> String {
        switch self.sceneType {
        case .createPost:
            return "Create Post Success"
            
        case .createComment:
            return "Create Comment Success"

        case .createCommentReply:
            return "Create Comment Reply Success"
        }
    }
    
    override func localizeTitles() {
        self.tagsTitleLabel.text = "Add Max 5 Tags".localized()
        self.postCreateView.titleTextField.placeholder = "Enter Post Title Placeholder".localized()
        contentTextView.placeholder     =   (sceneType == .createPost ? "Enter Text Placeholder" : "Enter Comment Placeholder").localized()
        self.navigationItem.title       =   (sceneType == .createPost) ? "Publish Title".localized() : "Comment Title Verb".localized()
    }

    
    // MARK: - Actions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        self.clearAllEnteredValues()
        self.router?.save(success: false)
        self.router?.routeToNextScene()
    }
    
    @IBAction func publishBarButtonTapped(_ sender: UIBarButtonItem) {
        guard isRequestAvailable() else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.postingActivityIndicator.startAnimating()
        })
        
        // Get content parts
        let contentParts = self.contentTextView.getParts()
        self.interactor?.save(attachments: contentParts)

        // API
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            let requestModel = PostCreateModels.Item.RequestModel(sceneType: self.sceneType)
            self.interactor?.publishItem(withRequestModel: requestModel)
        })
    }
}


// MARK: - PostCreateDisplayLogic
extension PostCreateViewController: PostCreateDisplayLogic {
    func displayPublishItem(fromViewModel viewModel: PostCreateModels.Item.ViewModel) {
        self.postingActivityIndicator.stopAnimating()
        
        // NOTE: Display the result from the Presenter
        guard viewModel.errorAPI == nil else {
            if let message = viewModel.errorAPI?.caseInfo.message {
                // Show alert view
                if message.contains("You may only post once every 5 minutes") {
                    self.showAlertView(withTitle: viewModel.errorAPI!.caseInfo.title, andMessage: "You may only post once every 5 minutes", needCancel: false, completion: { _ in })
                }
                
                // Modify 'permlink'
                else if message.contains("Result not found") {
                    print(message)
                }
                
                else if message.contains("parent_permlink") {
                    self.showAlertView(withTitle: viewModel.errorAPI!.caseInfo.title, andMessage: message, needCancel: false, completion: { _ in })
                }
                
                else if message.contains("permlink") {
                    self.showAlertView(withTitle: viewModel.errorAPI!.caseInfo.title, andMessage: message, needCancel: false, completion: { _ in })
                }
            }
            
            return
        }
        
        self.showAlertView(withTitle: "Info", andMessage: self.loadMessage(), needCancel: false, completion: { [weak self] _ in
            self?.router?.save(success: true)
            self?.router?.routeToNextScene()
            self?.clearAllEnteredValues()
        })
    }
}


// MARK: - UITextViewDelegate
extension PostCreateViewController: UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.theme_textColor    =   blackWhiteColorPickers
        self.firstResponder         =   self.contentTextView
        
        self.setConstraint()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
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
                    guard let linkKey = linkAlert.textFields![0].text, !linkKey.isEmpty else {
                        return
                    }
                    
                    guard let linkPath = linkAlert.textFields![1].text, !linkPath.isEmpty else {
                        return
                    }
                    
                    // Add (linkName, linkURL)
                    self?.contentTextView.add(object: (linkKey.replacingOccurrences(of: " ", with: "_"), linkPath))
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
                        imagePicker.mediaTypes      =   [kUTTypeImage as String]
                        imagePicker.allowsEditing   =   false
                        
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
                        imagePicker.mediaTypes      =   [kUTTypeImage as String]
                        imagePicker.allowsEditing   =   false
                        
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
                self?.setConstraint()
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true)

//        let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL
//        print(videoURL!)
//
//        do {
//            let asset = AVURLAsset(url: videoURL as! URL, options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//        } catch let error {
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//        }

//        let origImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        guard let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            showAlertView(withTitle: "Error", andMessage: "No image found", needCancel: false, completion: { _ in })

            return
        }

        picker.sourceType == .camera ? self.saveToAlbum(image: originalImage) : self.contentTextView.add(object: originalImage)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
