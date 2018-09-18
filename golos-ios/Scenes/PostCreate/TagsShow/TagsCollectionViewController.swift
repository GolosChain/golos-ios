//
//  TagsCollectionViewController.swift
//  golos-io
//
//  Created by msm72 on 18.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import AlignedCollectionViewFlowLayout
import IQKeyboardManagerSwift

class TagsCollectionViewController: GSBaseViewController {
    // MARK: - Properties
    var tags: [Tag]!
    var tagIndex: Int       =   1
    var offsetIndex: Int    =   -1
    var isKeyboardShow      =   false
    
    var addNewTagCell: AddTagCollectionViewCell!
    
    var completionTagsChanged: (() -> Void)?
    var completionStartEndEditing: ((CGFloat, CGFloat?) -> Void)?
    var complationCollectionViewChangeHeight: ((CGFloat) -> Void)?

    
    // MARK: - IBPutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset         =   UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            collectionView.delegate             =   self
            collectionView.dataSource           =   self
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UICollectionView alignment
        let alignedFlowLayout                   =   collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment  =   .left
        alignedFlowLayout?.verticalAlignment    =   .center
        
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName:                        "ThemeTagCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier:     "ThemeTagCollectionViewCell")

        self.collectionView!.register(UINib(nibName:                        "AddTagCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier:     "AddTagCollectionViewCell")

        // Create first tag
        self.createFirstTab()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func createFirstTab() {
        self.tags   =   [Tag]()
        let tag     =   Tag(placeholder: "Tag".localized() + " 1", id: tagIndex, isFirst: true)
        
        self.tags.append(tag)
        self.collectionView.reloadData()
        self.completionTagsChanged!()
    }
    
    private func addNewTag() {
        guard self.tags.count <= 4 else {
            self.showAlertView(withTitle: "Info", andMessage: "You can add up to 5 tags", needCancel: false, completion: { _ in })
            return
        }
        
        // Check current Tag title
        guard let title = self.tags.last?.title, !title.isEmpty else {
            return
        }
        
        self.tagIndex           +=  1
        let insertIndexPath     =   IndexPath(row: self.tags.count, section: 0)

        self.tags.append(Tag(placeholder: "Tag".localized() + " \(self.tags.count + 1)", id: self.tagIndex, isFirst: false))
        self.collectionView.insertItems(at: [insertIndexPath])
        self.collectionView.reloadItems(at: [insertIndexPath])

        self.calculateCollectionViewHeight()

        (self.collectionView.cellForItem(at: IndexPath(row: self.tags.count - 1, section: 0)) as! ThemeTagCollectionViewCell).textField.becomeFirstResponder()
        self.collectionView.collectionViewLayout.invalidateLayout()

    }
    
    func calculateCollectionViewHeight() {
        if let addTagCell = self.addNewTagCell {
            self.complationCollectionViewChangeHeight!(addTagCell.frame.maxY + 13.0 * heightRatio)
        }
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}


// MARK: - UICollectionViewDataSource
extension TagsCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.tags != nil else {
            return 0
        }
        
        return self.tags.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.row == self.tags.count {
            self.addNewTagCell  =   collectionView.dequeueReusableCell(withReuseIdentifier: "AddTagCollectionViewCell", for: indexPath) as? AddTagCollectionViewCell
            cell                =   self.addNewTagCell
            
            // Handler add button
            self.addNewTagCell.completionAddNewTag              =   { [weak self] in
                self?.addNewTag()
            }
            
           self.addNewTagCell.completionAddButtonChangeFrame    =   { [weak self] newFrame in
                self?.complationCollectionViewChangeHeight!((newFrame.maxY + 18.0) * heightRatio)
            }
        }
            
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeTagCollectionViewCell", for: indexPath) as! ThemeTagCollectionViewCell

            // First Tag
            if indexPath.row == 0 {
                (cell as! ThemeTagCollectionViewCell).clearButton.isHidden = true
            }
            
            // Configure the cell
            let item = (indexPath.row == self.tags.count) ? nil : self.tags[indexPath.row]
            (cell as! ConfigureCell).setup(withItem: item, andIndexPath: indexPath)
            
            // Handler clear button
            (cell as! ThemeTagCollectionViewCell).completionClearButton = { [weak self] isKeyboardShow in
                let deleteIndex         =   self?.tags.index(where: { $0.id == item?.id })!
                let deleteIndexPath     =   IndexPath(row: deleteIndex!, section: 0)
                self?.tags.remove(at: deleteIndex!)
                
                for (index, tag) in (self?.tags.enumerated())! {
                    tag.placeholder     =   "Tag".localized() + " \(index + 1)"
                    self?.tags[index]   =   tag
                }
                
                self?.collectionView?.deleteItems(at: [deleteIndexPath])
                
                if deleteIndex == self?.offsetIndex {
                    self?.offsetIndex   =   -1
                }
                
                // Last tag becomeFirstResponder
                if isKeyboardShow {
                    (self?.collectionView.cellForItem(at: IndexPath(row: (self?.tags.count)! - 1, section: 0)) as! ThemeTagCollectionViewCell).textField.becomeFirstResponder()
                }
                
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
            
            // Handler end editing
            (cell as! ThemeTagCollectionViewCell).completionEndEditing = {
                guard self.tags != nil else {
                    self.view.endEditing(true)
                    return
                }
                
                self.tags.forEach({
                    if let tagCell = cell as? ThemeTagCollectionViewCell, let title = tagCell.textField.text, $0.id == tagCell.textField.tag {
                        $0.title = title
                    }
                })
                
                if let addTagCell = self.collectionView.visibleCells.first(where: { $0 is AddTagCollectionViewCell }), !IQKeyboardManager.sharedManager().keyboardShowing {
                    self.completionStartEndEditing!(0.0, addTagCell.frame.maxY)
                }
            }
            
            // Handler start editing
            (cell as! ThemeTagCollectionViewCell).completionStartEditing = {
                self.completionStartEndEditing!((UIApplication.shared.statusBarOrientation.isPortrait ? 150.0 : 100.0) * heightRatio, nil)
            }
            
            // Handler change title
            (cell as! ThemeTagCollectionViewCell).completionChangeTitle = { [weak self] offset, enteredName, newCharacter in
                self?.offsetIndex       =   indexPath.row
                item?.cellWidth         =   offset
                
                // Add new Tag
                if !(enteredName?.isEmpty)! && newCharacter == " " {
                    self?.addNewTag()
                }
                
                else {
                    self?.tags.forEach({
                        if let tagCell = cell as? ThemeTagCollectionViewCell, $0.id == tagCell.textField.tag {
                            $0.title = (newCharacter.isEmpty ?  String(enteredName![enteredName!.startIndex ..< enteredName!.index(enteredName!.endIndex, offsetBy: -1)]) :
                                                                enteredName! + newCharacter).lowercased()
                        }
                    })
                    
                    // Send updated tags
                    self?.completionTagsChanged!()
                }
                
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension TagsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension TagsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard self.tags != nil else {
            return 0.0
        }
        
        return 6.0 * widthRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9.0 * heightRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Add button cell
        guard self.tags != nil else {
            return .zero
        }
        
        if indexPath.row > self.tags.count - 1 {
            self.calculateCollectionViewHeight()
            return CGSize(width: 46.0 * widthRatio, height: 30.0 * heightRatio)
        }
        
        // Tag cell
        else {
            return CGSize.init(width: self.tags[indexPath.row].cellWidth, height: 30.0 * heightRatio)
        }
    }
}
