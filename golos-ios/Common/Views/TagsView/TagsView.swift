//
//  TagsView.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class TagsView: UIView {
    private let tagCellIdentifier = String(describing: TagCollectionViewCell.self)
    
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionViewCenteredLayout())
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var tagStringArray = [String]() {
        didSet {
            collectionView.reloadData()
            if tagStringArray.count == 0 {
                collectionViewHeightConstraint.constant = 0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint.isActive = true
        
        let cellNib = UINib(nibName: tagCellIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: tagCellIdentifier)
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 60, height: 20)
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16)
        
        if tagStringArray.count == 0 {
            collectionViewHeightConstraint.constant = 0
        }
    }
    
    //MARK: KVO
    private func addObserving() {
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    private func removeObserving() {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let _ = object as? UICollectionView,
            let change = change,
            let new = change[NSKeyValueChangeKey.newKey] as? NSValue else {
            return
        }
        let newContentSize = new.cgSizeValue
        collectionViewHeightConstraint.constant = newContentSize.height
    }
}

extension TagsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagStringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as! TagCollectionViewCell
        cell.tagButton.tagTitle = tagStringArray[indexPath.row]
        return cell
    }
}

