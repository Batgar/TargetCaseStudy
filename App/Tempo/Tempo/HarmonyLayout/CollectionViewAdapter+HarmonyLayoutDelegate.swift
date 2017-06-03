//
//  CollectionViewAdapter+HarmonyLayoutDelegate.swift
//  HarmonyKit
//
//  Created by Samuel Kirchmeier on 2/24/16.
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

extension CollectionViewAdapter: HarmonyLayoutDelegate {
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, heightForItemAtIndexPath indexPath: IndexPath, forWidth: CGFloat) -> CGFloat {
        return harmonyLayoutComponentFor(indexPath)?
            .heightForLayout(harmonyLayout, item: itemFor(indexPath), width: forWidth) ?? harmonyLayout.defaultItemHeight
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForSection section: Int) -> HarmonyLayoutMargins {
        let indexPath = IndexPath(item: 0, section: section)
        return harmonyLayoutComponentFor(indexPath)?
            .sectionMarginsForLayout(harmonyLayout) ?? harmonyLayout.defaultSectionMargins
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForItemAtIndexPath indexPath: IndexPath) -> HarmonyLayoutMargins {
        return harmonyLayoutComponentFor(indexPath)?
            .itemMarginsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultItemMargins
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, styleForItemAtIndexPath indexPath: IndexPath) -> HarmonyCellStyle {
        return harmonyLayoutComponentFor(indexPath)?
            .styleForLayout(harmonyLayout, item: itemFor(indexPath)) ?? .grouped
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, separatorInsetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutComponentFor(indexPath)?
            .separatorInsetsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? UIEdgeInsets.zero
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileSizeForItemAtIndexPath indexPath: IndexPath) -> HarmonyTileSize {
        return harmonyLayoutComponentFor(indexPath)?.tileSizeForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileSize
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileSpacingForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return harmonyLayoutComponentFor(indexPath)?.tileSpacingForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileSpacing
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileInsetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutComponentFor(indexPath)?.tileInsetsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileInsets
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileMarginsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutComponentFor(indexPath)?.tileMarginsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileMargins
    }

    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, styleForSection section: Int) -> HarmonySectionStyle {
        let indexPath = IndexPath(item: 0, section: section)
        return harmonyLayoutComponentFor(indexPath)?.sectionStyleForLayout(harmonyLayout) ?? harmonyLayout.defaultSectionStyle
    }

    fileprivate func harmonyLayoutComponentFor(_ indexPath: IndexPath) -> HarmonyLayoutComponent? {
        return componentFor(indexPath) as? HarmonyLayoutComponent
    }
}
