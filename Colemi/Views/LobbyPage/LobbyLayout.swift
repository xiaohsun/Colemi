//
//  LobbyLayout.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import UIKit

protocol LobbyLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

class LobbyLayout: UICollectionViewLayout {
    weak var delegate: LobbyLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    // private var testCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func invalidateLayout() {
        cache = []
    }
    
    override func prepare() {
        
        // 找出要算的人，就算那些人
        // 以下不能這樣判斷
        // testCache = [:]
        // cache = []
        
        guard cache.isEmpty, let collectionView = collectionView else { return }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoSize = delegate!.collectionView(collectionView, sizeForPhotoAtIndexPath: indexPath)
            
            let cellWidth = columnWidth
            let cellHeight = photoSize.height * cellWidth / photoSize.width
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: cellWidth,
                               height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            // 要 append 新的東西
            // testCache[indexPath] = attributes
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += cellHeight
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        // return testCache[indexPath]
       return cache[indexPath.item]
    }
}
