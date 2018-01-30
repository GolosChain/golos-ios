//
//  CollectionViewCenteredLayout.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    func leftAlignFrameWithSectionInset(sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

class CollectionViewCenteredLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var updatedAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in originalAttributes where attribute.representedElementKind == nil {
//            if attribute.representedElementKind == nil {
                updatedAttributes.append(self.layoutAttributesForItem(at: attribute.indexPath)!)
//            }
        }
        
        return updatedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let current = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        let sectionInset = self.sectionInset
        
        let isFirstItem = indexPath.item == 0
        let layoutWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right
        
        if isFirstItem {
            current.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
            return current
        }
        
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousFrame = layoutAttributesForItem(at: previousIndexPath)!.frame
        let currentFrame = current.frame
        let stretchedCurrentFrame = CGRect(
            x: sectionInset.left,
            y: currentFrame.origin.y,
            width: layoutWidth,
            height: currentFrame.size.height
        )
        
        let isFirstItemInRow = !previousFrame.intersects(stretchedCurrentFrame)
        
        if isFirstItemInRow {
            current.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
            return current
        }
        
        var frame = current.frame
        frame.origin.x = previousFrame.maxX + self.minimumInteritemSpacing
        current.frame = frame
        
        return current
    }
}
