//
//  HarmonyLayoutDelegate.swift
//  Harmony
//
//  Created by Samuel Kirchmeier on 4/16/15.
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Allows a collection view delegate to customize the attributes of sections and items.
 */
@objc
public protocol HarmonyLayoutDelegate: UICollectionViewDelegate {
    /**
     Asks the delegate for the height of the specified item. If this function isn't specified, then
     the layout's defaultItemHeight property is used instead.
     
     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path of the item.
     
     - Returns: The height of the specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, heightForItemAtIndexPath indexPath: NSIndexPath, forWidth: CGFloat) -> CGFloat
    
    /**
     Asks the delegate for the margins for the specified section. If this function isn't specified,
     then the layout's defaultSectionMargins are used instead.
     
     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter section:       The section.
     
     - Returns: The margins for the specified section.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, marginsForSection section: Int) -> HarmonyLayoutMargins
    
    /**
     Asks the delegate for the margins for the specified item. If this function isn't specified,
     then the layout's defaultItemMargins are used instead.
     
     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.
     
     - Returns: The margins for the specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, marginsForItemAtIndexPath indexPath: NSIndexPath) -> HarmonyLayoutMargins
    
    /**
     Asks the delegate for the separator inset of the item at the specified index path. If this function isn't
     specified, then `UIEdgeInsetsZero` is used instead.
     
     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.
     
     - Returns: The separator insets for specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, separatorInsetsForItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets
    
    /**
     Asks the delegate for the style of the item at the specified index path. If this function isn't
     specified, then the .Grouped style is used instead.
     
     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.
     
     - Returns: The style for specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, styleForItemAtIndexPath indexPath: NSIndexPath) -> HarmonyCellStyle
    
    /**
     Asks the delegate if there should be a line break after the provided index path in a grouped 
     cell style. If this function isn't specified, then it will assume `false`.
     
     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.
     
     - Returns: A boolean indicating if there should be a break after the provided index path.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, breakAtIndexPath indexPath: NSIndexPath) -> Bool

    /**
     Asks the delegate for the style of the specified section. If this function isn't specified then
     the layout's `defaultSectionStyle` is used instead

     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter section:       The section.

     - Returns: The style for the specified section. See `HarmonySectionStyle` for possible values.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, styleForSection section: Int) -> HarmonySectionStyle

    /**
     Asks the delegate for the tile size of the specified item. If this function isn't specified, then
     the layout's `defaultTileSize` property is used instead.

     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path of the item.

     - Returns: The tile size of the specified item. See `HarmonyTileSize` for possible values.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, tileSizeForItemAtIndexPath indexPath: NSIndexPath) -> HarmonyTileSize

    /**
     Asks the delegate for the tile insets of the item at the specified index path. If this function isn't
     specified, then `defaultTileInsets` is used instead.
     
     Tile insets is the space between the first or last tile and the section margins.

     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.

     - Returns: The tile insets for the specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, tileInsetsForItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets

    /**
     Asks the delegate for the spacing between items at the specified index path. If this function isn't
     specified, then `defaultTileSpacing` is used instead.
     
     Tile spacing is the space between a tile and it's neighboring tiles.

     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.

     - Returns: The tile spacing for the specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, tileSpacingForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat

    /**
     Asks the delegate for the tile margins of the item at the specified index path. If this function isn't
     specified, then `defaultTileMargins` is used instead.
     
     Tile margins is the space between the tile and it's content view.

     - Parameter harmonyLayout: The layout for the collection view.
     - Parameter indexPath:     The index path for the item.

     - Returns: The tile margins for the specified item.
     */
    optional func harmonyLayout(harmonyLayout: HarmonyLayout, tileMarginsForItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets
}



