//
//   PinterestLayout.swift
//  CVApp
//
//  Created by Victor Chang on 02/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class HeaderLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) as! [UICollectionViewLayoutAttributes]
        
        let offset = collectionView!.contentOffset
        if(offset.y < 0) {
            let deltaY = abs(offset.y)
            for attributes in layoutAttributes {
                if let elementKind = attributes.representedElementKind {
                    if elementKind == UICollectionView.elementKindSectionHeader {
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSize.height + deltaY)
                        frame.origin.y = frame.minY - deltaY
                        attributes.frame = frame
                    }
                }
            }
        }
        
        return layoutAttributes
    }
    
}
