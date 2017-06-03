//
//  HarmonyLayoutComponent.swift
//  HarmonyKit
//
//  Created by Adam May on 11/16/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public protocol HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat
    func itemMarginsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyLayoutMargins
    func sectionMarginsForLayout(_ layout: HarmonyLayout) -> HarmonyLayoutMargins
    func styleForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyCellStyle
    func separatorInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
    func sectionStyleForLayout(_ layout: HarmonyLayout) -> HarmonySectionStyle
    func tileSizeForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyTileSize
    func tileInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
    func tileSpacingForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> CGFloat
    func tileMarginsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
}

public extension HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return layout.defaultItemHeight
    }

    func itemMarginsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyLayoutMargins {
        return layout.defaultItemMargins
    }

    func sectionMarginsForLayout(_ layout: HarmonyLayout) -> HarmonyLayoutMargins {
        return layout.defaultSectionMargins
    }

    func styleForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyCellStyle {
        return .grouped
    }
    
    func separatorInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func tileSizeForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyTileSize {
        return layout.defaultTileSize
    }

    func tileInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultTileInsets
    }

    func tileSpacingForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> CGFloat {
        return layout.defaultTileSpacing
    }

    func tileMarginsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultTileMargins
    }

    func sectionStyleForLayout(_ layout: HarmonyLayout) -> HarmonySectionStyle {
        return layout.defaultSectionStyle
    }

    func fittingHeightForView(_ componentView: UIView, width: CGFloat) -> CGFloat {
        componentView.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(item: componentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        componentView.addConstraint(widthConstraint)

        componentView.setNeedsLayout()
        componentView.layoutIfNeeded()

        let fittingSize = componentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        componentView.removeConstraint(widthConstraint)

        return fittingSize.height
    }
}
