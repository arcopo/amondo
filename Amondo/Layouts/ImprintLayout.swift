//
//  ImprintLayout.swift
//  Amondo
//
//  Created by James Bradley on 10/05/2016.
//  Copyright © 2016 Amondo. All rights reserved.
//

import UIKit

class ImprintLayout: UICollectionViewLayout {
    
    private var cache = [UICollectionViewLayoutAttributes]()
        
    var cellSpacing:            CGFloat = 0.5
    var delegate:               ImprintCollectionViewController!
    var currentSection = 0  {
        didSet {
            self.cache.removeAll()
            self.prepareLayout()
        }
    }
    
    var layoutConfigs: NSDictionary?
    
    private var contentHeight: CGFloat {
        return CGRectGetHeight(delegate.collectionView!.bounds)
    }

    private var contentWidth: CGFloat {
        return CGRectGetWidth(delegate.collectionView!.bounds)
    }
    
    override init() {
        super.init()
        
        let path = NSBundle.mainBundle().pathForResource("Layouts", ofType: "plist")
        layoutConfigs = NSDictionary(contentsOfFile: path!)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareLayout() {
        for section in 0 ..< delegate.collectionView!.numberOfSections() {
            
            for item in 0 ..< delegate.collectionView!.numberOfItemsInSection(section) {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let frame = tileFrameAtIndex(indexPath)
                let insetFrame = CGRectInset(frame, cellSpacing, cellSpacing)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                
                self.cache.append(attributes)
            }
        }
    }
    
    func tileFrameAtIndex(indexPath: NSIndexPath) -> CGRect {
        let key = String(delegate.collectionView!.numberOfItemsInSection(indexPath.section))
        let layoutConfig = layoutConfigs![key] as! NSArray
        var location: String
        
        if currentSection > indexPath.section {
            location = "top"
        } else if currentSection == indexPath.section {
            location = "centre"
        } else {
            location = "bottom"
        }
        
        let itemLayoutConfig = layoutConfig[indexPath.item][location] as! [Double]
        let width = itemLayoutConfig[1] - itemLayoutConfig[3]
        
        let height = itemLayoutConfig[2] - itemLayoutConfig[0]
        
        let rect = CGRect(
            x: CGFloat(itemLayoutConfig[3]) * contentWidth,
            y: CGFloat(itemLayoutConfig[0]) * contentHeight,
            width: CGFloat(width) * contentWidth,
            height: CGFloat(height) * contentHeight
        )
        return rect
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let frame = tileFrameAtIndex(indexPath)
        
        let insetFrame = CGRectInset(frame, cellSpacing, cellSpacing)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = insetFrame
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
                
        for attributes in cache {
            layoutAttributes.append(attributes)
        }
        
        return layoutAttributes
    }
}
