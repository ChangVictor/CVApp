//
//   StrechyHeaderLayout.swift
//  CVApp
//
//  Created by Victor Chang on 02/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class StrechyHeaderLayout: UICollectionViewFlowLayout {
    
    // we want to modify the attributes of our header component
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                
                let contentsOffsetY = collectionView.contentOffset.y
                
                if contentsOffsetY > 0 {
                    return
                }
                
                let width = collectionView.frame.width
                let height = attributes.frame.height - contentsOffsetY
                
                attributes.frame = CGRect(x: 0, y: contentsOffsetY, width: width, height: height)
                
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
