//
//  CustomClassLayout.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

protocol CustomClassLayoutDelegate {
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath, with width: CGFloat) -> CGFloat
}

class CustomClassLayout: UICollectionViewLayout {
    //1. Pinterest Layout Delegate
    var delegate: CustomClassLayoutDelegate!
    
    //2. Configurable properties

    var numberOfColumns: CGFloat = 2
    private var cellPadding: CGFloat = 10.0
    
    //3. Array to keep a cache of attributes.
    var attributesCache = [UICollectionViewLayoutAttributes]()

    
    //4. Content height and size
    var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    
    //MARK: getters
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare ()
    {
        attributesCache.removeAll()
        //if cache.isEmpty {
            let collumnWidth = contentWidth / CGFloat(numberOfColumns)
            let cellWidth = collumnWidth - (cellPadding * 2)
            
            var xOffsets = [CGFloat]()
            
            for collumn in 0..<Int(numberOfColumns) {
                xOffsets.append(CGFloat(collumn) * collumnWidth)
            }
            
        for _ in 0..<collectionView!.numberOfItems(inSection: 0) {
            let numberOfItems = collectionView!.numberOfItems(inSection: 0)
                
            var yOffsets = [CGFloat](repeating: 0, count:Int(numberOfColumns))
            
            for item in 0..<numberOfItems {
                let indexPath = NSIndexPath(item: item, section: 0)
                
                let column = yOffsets.firstIndex(of: yOffsets.min()!) ?? 0
                
                if delegate == nil { return }
                let imageHeight = delegate.collectionView(
                    collectionView: collectionView!,
                    heightForPhotoAtIndexPath: indexPath,
                    with: cellWidth
                )
                
                let cellHeight = cellPadding + imageHeight  + cellPadding
                
                let frame = CGRect(
                    x: xOffsets[column],
                    y: yOffsets[column],
                    width: collumnWidth,
                    height: cellHeight
                )
                
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = PinterestLayoutAttributes(
                    forCellWith: indexPath as IndexPath
                )
                attributes.frame = insetFrame
                attributes.photoHeight = imageHeight
                attributesCache.append(attributes)
                
                
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + cellHeight
            }
        }
    }

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
}

// UICollectionViewFlowLayout
// abstract

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes
{
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.photoHeight  = photoHeight
        return copy
    }

}
