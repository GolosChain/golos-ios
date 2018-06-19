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
    
    // KVO
    var collectionContentSizeObserver: NSKeyValueObservation?

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
        
        collectionContentSizeObserver = collectionView.observe(\.contentSize, options: [.new]) { object, _ in
            let newContentSize = object.contentSize
            self.collectionViewHeightConstraint.constant = newContentSize.height
            
        }
        
        
        let cellNib = UINib(nibName: tagCellIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: tagCellIdentifier)
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 60, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if tagStringArray.count == 0 {
            collectionViewHeightConstraint.constant = 0
        }
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
