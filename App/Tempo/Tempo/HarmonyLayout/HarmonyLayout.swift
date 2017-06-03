//
//  HarmonyLayout.swift
//  Harmony
//
//  Created by Samuel Kirchmeier on 4/10/15.
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Harmony-styled collection view layout. Designed to handle all of the cell styles defined for the
 *  Target app.
 */
open class HarmonyLayout: UICollectionViewLayout {

    static let backdropViewKind = "backdrop"

    // MARK: - Internal Properties

    /// Indicates whether or not to collapse the first section's top margin. Default is true.
    open var collapseFirstSectionTopMargin = true
    
    /// Indicates whether or not to collapse the last section's bottom margin. Default is true.
    open var collapseLastSectionBottomMargin = true
    
    /// Margins that surround the entire collection view.
    open var collectionViewMargins = HarmonyLayoutMargins(top: .narrow, right: .none, bottom: .narrow, left: .none)
    
    /// Default section margins.
    open var defaultSectionMargins = HarmonyLayoutMargins(top: .none, right: .none, bottom: .wide, left: .none)
    
    /// Default item margins.
    open var defaultItemMargins = HarmonyLayoutMargins(top: .none, right: .narrow, bottom: .none, left: .narrow)
    
    /// Default item height.
    open var defaultItemHeight = CGFloat(44.0)

    /// Default sections style. Used when the delegate does not specify section style.
    open var defaultSectionStyle: HarmonySectionStyle = .list

    /// Default tile size. Used when the delegate does not specify tile size.
    open var defaultTileSize: HarmonyTileSize = .wide

    /// Default tile insets. Used when the delegate does not specify tile insets.
    open var defaultTileInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)

    // Default tile margins. Used when the delegate does not specify tile margins.
    open var defaultTileMargins: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

    // Default tile spacing. Used when the delegate does not specify tile spacing.
    open var defaultTileSpacing: CGFloat = 0

    // A Boolean value indicating whether a backdrop appears behind the collection view's content.
    open var displaysBackdrop = false
    
    // MARK: - Private Properties
    
    fileprivate var cachedContentSize = CGSize.zero
    fileprivate var currentAttributes: [IndexPath: HarmonyCellAttributes] = [:]

    // The backdrop appears behind all the views displayed for the collection view's items.
    fileprivate var backdropAttributes: UICollectionViewLayoutAttributes?

    // MARK: - Lifecycle methods

    public override init() {
        super.init()
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        register(HarmonyBackdropView.self, forDecorationViewOfKind: HarmonyLayout.backdropViewKind)
    }
}

class HarmonyBackdropView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        backgroundColor = .targetFadeAwayGrayColor
    }
}

// MARK: - UICollectionViewLayout

public extension HarmonyLayout {

    var contentSizeWidth: CGFloat {
        return collectionView?.bounds.size.width ?? 0.0
    }

    var harmonyLayoutDelegate: HarmonyLayoutDelegate? {
        return collectionView?.delegate as? HarmonyLayoutDelegate
    }

    func tileSize(forIndexPath indexPath: IndexPath) -> HarmonyTileSize {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileSizeForItemAtIndexPath: indexPath) ?? defaultTileSize
    }

    func tileInsets(forIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileInsetsForItemAtIndexPath: indexPath) ?? defaultTileInsets
    }

    func tileSpacing(forIndexPath indexPath: IndexPath) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileSpacingForItemAtIndexPath: indexPath) ?? defaultTileSpacing
    }

    func tileMargins(forIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileMarginsForItemAtIndexPath: indexPath) ?? defaultTileMargins
    }

    func style(forSection section: Int) -> HarmonySectionStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, styleForSection: section) ?? defaultSectionStyle
    }

    func hasBreak(atIndexPath indexPath: IndexPath) -> Bool {
        return harmonyLayoutDelegate?.harmonyLayout?(self, breakAtIndexPath: indexPath) ?? false
    }

    func margins(forSection section: Int) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForSection: section) ?? defaultSectionMargins
    }

    func margins(forItemAtIndexPath indexPath: IndexPath) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForItemAtIndexPath: indexPath) ?? defaultItemMargins
    }

    func style(forItemAtIndexPath indexPath: IndexPath) -> HarmonyCellStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, styleForItemAtIndexPath: indexPath) ?? .grouped
    }

    func separatorInsets(forItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, separatorInsetsForItemAtIndexPath: indexPath) ?? UIEdgeInsets.zero
    }

    func height(forItemAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, heightForItemAtIndexPath: indexPath, forWidth:width) ?? defaultItemHeight
    }

    func width(forSection section: Int) -> CGFloat {
        let sectionMargins = margins(forSection: section)

        return contentSizeWidth - sectionMargins.left.points - sectionMargins.right.points
    }

    func width(forItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let itemMargins = margins(forItemAtIndexPath: indexPath)

        return width(forSection: indexPath.section) - itemMargins.left.points - itemMargins.right.points
    }
    
    func groupFramesForSection(_ section: Int) -> [CGRect]? {
        return currentAttributes.filter { $0.0.section == section } // Grab the attributes for the specified section
            .sorted(by: {left, right in left.0.item < right.0.item })
            .reduce([CGRect]()) { (groupFrames, currentFrame) in // Combine touching items into grouped frames.
                var mutableGroupFrames = groupFrames
                
                if let lastTest = mutableGroupFrames.last, lastTest.maxY == currentFrame.1.frame.minY,
                       let last = mutableGroupFrames.popLast() {
                    mutableGroupFrames.append(last.union(currentFrame.1.frame))
                } else {
                    mutableGroupFrames.append(currentFrame.1.frame)
                }
                return mutableGroupFrames
            }
    }

    override open func prepare() {
        super.prepare()

        currentAttributes.removeAll(keepingCapacity: true)

        let contentSizeWidth = collectionView?.bounds.size.width ?? 0.0
        let contentSizeHeight = collectionView?.bounds.size.height ?? 0.0
        var y = collectionViewMargins.top.points

        if let collectionView = collectionView {
            let sectionCount = collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 1
            
            for sectionIndex in 0..<sectionCount {
                if let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: sectionIndex), itemCount > 0 {
                    let sectionMargins = margins(forSection: sectionIndex)

                    let isFirstSection = sectionIndex == 0
                    if !isFirstSection || !collapseFirstSectionTopMargin {
                        let topMargin = sectionMargins.top.points
                        y += topMargin
                    }

                    var maxY: CGFloat = 0

                    let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: sectionIndex) }
                    let section = HarmonyLayoutSection(indexPaths: indexPaths, layout: self, style: style(forSection: sectionIndex)).offsetBy(y)

                    for attributes in section {
                        // Moves all item attributes in front of any decoration or supplementary 
                        // views, such as the backdrop.
                        attributes.zIndex = 100

                        currentAttributes[attributes.indexPath] = attributes
                        maxY = attributes.frame.maxY
                    }

                    y = maxY

                    let isLastSection = sectionIndex == sectionCount - 1
                    // Only execute this if at least one item was in the section. Otherwise, it shouldn't
                    // "count" against the next margin.
                    if itemCount > 0 && (!isLastSection || !collapseLastSectionBottomMargin) {
                        let bottomMargin = sectionMargins.bottom.points
                        y += bottomMargin
                    }
                }
            }
        }
        
        y += collectionViewMargins.bottom.points
        cachedContentSize = CGSize(width: contentSizeWidth, height: y)

        if displaysBackdrop && currentAttributes.count > 0 {
            backdropAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: HarmonyLayout.backdropViewKind, with: IndexPath(item: 0, section: 0))
            backdropAttributes?.frame = CGRect(x: 0, y: 0, width: cachedContentSize.width, height: cachedContentSize.height + contentSizeHeight)
        }
    }
    
    override open var collectionViewContentSize : CGSize {
        return cachedContentSize
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var intersection = [UICollectionViewLayoutAttributes]()
        
        for attributes in currentAttributes.values {
            if rect.intersects(attributes.frame) {
                intersection.append(attributes)
            }
        }

        if let backdropAttributes = backdropAttributes, backdropAttributes.frame.intersects(rect) {
            intersection.append(backdropAttributes)
        }
        
        return intersection
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[indexPath]
    }

    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return backdropAttributes
    }

    open override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return backdropAttributes
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds ?? CGRect.zero
        let sizeChanged = !oldBounds.size.equalTo(newBounds.size)
        
        return sizeChanged
    }
}
