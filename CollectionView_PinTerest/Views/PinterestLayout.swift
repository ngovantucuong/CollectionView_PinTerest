//
//  PinterestLayout.swift
//  CollectionView_PinTerest
//
//  Created by ngovantucuong on 9/2/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, forHeightPhoToAt indexPath: IndexPath, with Width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, forHeightCaptionAt indexPath: IndexPath, with Width: CGFloat) -> CGFloat
}

class PinterestLayoutAttribute: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttribute
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttribute {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class PinterestLayout: UICollectionViewLayout {
    var delegate: PinterestLayoutDelegate?
    var numberOfColumn: CGFloat = 2.0
    var cellPadding: CGFloat = 5.0
    
    private var attributesCache = [PinterestLayoutAttribute]()
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView?.contentInset
        return (collectionView!.bounds.width - (insets!.left + insets!.right))
    }
    
    override func prepare() {
        if attributesCache.isEmpty {
            let columnWidth = contentWidth / numberOfColumn
            var xOffset = [CGFloat]()
            
            for column in 0..<Int(numberOfColumn) {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            
            var yOffset = [CGFloat](repeating: 0, count: Int(numberOfColumn))
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = NSIndexPath(item: item, section: 0)
                let width = columnWidth - cellPadding * 2
                
                let photoHeight: CGFloat = (delegate?.collectionView(collectionView: collectionView!, forHeightPhoToAt: indexPath as IndexPath, with: width))!
                let captionHeight: CGFloat = (delegate?.collectionView(collectionView: collectionView!, forHeightCaptionAt: indexPath as IndexPath, with: width))!
                
                let height = cellPadding + photoHeight + captionHeight + cellPadding
                
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = PinterestLayoutAttribute(forCellWith: indexPath as IndexPath)
                attributes.frame = insetFrame
                attributes.photoHeight = photoHeight
                attributesCache.append(attributes)
                
                // update column and yOffset
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                if column >= Int(numberOfColumn - 1) {
                    column = 0
                } else {
                    column += 1
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in attributesCache {
            if attribute.frame.intersects(rect) {
                layoutAttributes.append(attribute)
            }
        }
        return layoutAttributes
    }
}
