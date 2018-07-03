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

class TagsCollectionViewController: BaseViewController {
    // MARK: - Properties
    var tags: [Tag]!
    var tagIndex: Int       =   1
    var offsetIndex: Int    =   -1
    var addButtonTapped     =   false
    var isKeyboardShow      =   false
    
    var completionStartEndEditing: ((CGFloat, CGFloat?) -> Void)?
    var complationCollectionViewChangeHeight: ((CGFloat) -> Void)?

    
    // MARK: - IBPutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate     =   self
            collectionView.dataSource   =   self
        }
    }
    
    
    // MARK: - Class Functions
    override func viewWillLayoutSubviews() {
        print(collectionView.frame.height)
    }
    
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
                                      forCellWithReuseIdentifier:           "AddTagCollectionViewCell")

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
    }
}


// MARK: - UICollectionViewDataSource
extension TagsCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.row == self.tags.count {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTagCollectionViewCell", for: indexPath) as! AddTagCollectionViewCell
            
            // Handler add button
            (cell as! AddTagCollectionViewCell).completionAddNewTag = {
                // Show alert
                guard self.tags.count <= 4 else {
                    self.showAlertView(withTitle: "Info", andMessage: "You can add up to 5 tags", needCancel: false, completion: { [weak self] _ in
                        self?.addButtonTapped = false
                    })
                    
                    return
                }
                
                // Check current Tag title
                guard !(self.tags.last?.title.isEmpty)! else {
                    self.addButtonTapped = false
                    return
                }
                
                self.tagIndex += 1
                let insertIndexPath = IndexPath(row: self.tags.count, section: 0)
                self.tags.append(Tag(placeholder: "Tag".localized() + " \(self.tags.count + 1)", id: self.tagIndex, isFirst: false))
                self.collectionView?.insertItems(at: [insertIndexPath])
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.addButtonTapped = true

                (self.collectionView.cellForItem(at: IndexPath(row: self.tags.count - 1, section: 0)) as! ThemeTagCollectionViewCell).textField.becomeFirstResponder()
            }
        }
            
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeTagCollectionViewCell", for: indexPath) as! ThemeTagCollectionViewCell

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
                _ = self.tags.map({
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
            (cell as! ThemeTagCollectionViewCell).completionChangeTitle = { [weak self] offset in
                self?.addButtonTapped   =   false
                self?.offsetIndex       =   indexPath.row
                item?.cellWidth         =   offset
                
                _ = self?.tags.map({
                    if let tagCell = cell as? ThemeTagCollectionViewCell, let title = tagCell.textField.text, $0.id == tagCell.textField.tag {
                        $0.title = title
                    }
                })
                
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
        if let height = collectionView.cellForItem(at: IndexPath(row: self.tags.count, section: 0))?.frame.maxY {
            self.complationCollectionViewChangeHeight!((height + 18.0) * heightRatio)
        }

        return 6.0 * widthRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9.0 * heightRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Add button cell
        if indexPath.row > self.tags.count - 1 {
            return CGSize(width: 46.0 * widthRatio, height: 30.0 * heightRatio)
        }
        
        // Tag cell
        else {
            return CGSize.init(width: self.tags[indexPath.row].cellWidth, height: 30.0 * heightRatio)
        }
    }
}
