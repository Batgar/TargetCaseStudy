//
//  CollectionViewAdapter.swift
//  HarmonyKit
//
//  Created by Adam May on 11/13/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public final class CollectionViewAdapter: NSObject {
    weak var scrollViewDelegate: UIScrollViewDelegate?

    let collectionView: UICollectionView
    fileprivate let componentProvider: ComponentProvider
    fileprivate var viewState: TempoSectionedViewState = InitialViewState()
    fileprivate var focusingIndexPath: IndexPath?

    fileprivate struct InitialViewState: TempoSectionedViewState {
        var sections: [TempoViewStateItem] {
            return []
        }
    }

    // MARK: - Init

    public init(collectionView: UICollectionView, componentProvider: ComponentProvider) {
        self.collectionView = collectionView
        self.componentProvider = componentProvider

        super.init()

        componentProvider.registerComponents(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Public Methods

    public func itemFor(_ indexPath: IndexPath) -> TempoViewStateItem {
        return itemFor(indexPath, inViewState: viewState)
    }

    public func sectionFor(_ section: Int) -> TempoViewStateItem {
        return viewState.sections[section]
    }

    public func componentFor(_ indexPath: IndexPath) -> ComponentType {
        let item = itemFor(indexPath)
        return componentProvider.componentFor(item)
    }

    // MARK: - Private Methods

    fileprivate func insertSection(_ section: Int) {
        collectionView.insertSections(IndexSet(integer: section))
    }

    fileprivate func deleteSection(_ section: Int) {
        collectionView.deleteSections(IndexSet(integer: section))
    }

    fileprivate func updateSection(_ fromSection: Int, fromViewState: TempoSectionedViewState, toSection: Int) {
        let section = fromViewState.sections[fromSection]

        for item in 0..<section.numberOfItems {
            let fromIndexPath = IndexPath(item: item, section: fromSection)
            let toIndexPath = IndexPath(item: item, section: toSection)
            itemInfoForIndexPath(fromIndexPath, fromViewState: fromViewState, toIndexPath: toIndexPath).configureView()
        }
    }

    fileprivate func updateSection(_ fromSection: Int, fromViewState: TempoSectionedViewState, toSection: Int, itemUpdates: [CollectionViewItemUpdate]) {
        for update in itemUpdates {
            switch update {
            case .delete(let item):
                collectionView.deleteItems(at: [IndexPath(item: item, section: fromSection)])

            case .insert(let item):
                collectionView.insertItems(at: [IndexPath(item: item, section: toSection)])

            case .update(let fromItem, let toItem):
                let fromIndexPath = IndexPath(item: fromItem, section: fromSection)
                let toIndexPath = IndexPath(item: toItem, section: toSection)
                itemInfoForIndexPath(fromIndexPath, fromViewState: fromViewState, toIndexPath: toIndexPath).configureView()
            }
        }
    }

    fileprivate func reloadSection(_ section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }

    fileprivate func focus(_ focus: TempoFocus) {
        guard focus.indexPath != focusingIndexPath else { // Scroll already in progress
            return
        }

        guard let attributes = collectionView.layoutAttributesForItem(at: focus.indexPath) else {
            return
        }

        let scrollPosition: UICollectionViewScrollPosition

        switch focus.position {
        case .centeredHorizontally:
            scrollPosition = .centeredHorizontally

        case .centeredVertically:
            scrollPosition = .centeredVertically
        }

        if collectionView.bounds.contains(attributes.frame) {
            // The item is already fully visible.
            didFocus(focus.indexPath, attributes: attributes)
        } else if focus.animated {
            // Track index path during animation. Reset in `scrollViewDidEndScrollingAnimation:`.
            focusingIndexPath = focus.indexPath
            collectionView.scrollToItem(at: focus.indexPath, at: scrollPosition, animated: true)
        } else {
            collectionView.scrollToItem(at: focus.indexPath, at: scrollPosition, animated: false)
            didFocus(focus.indexPath, attributes: attributes)
        }
    }

    fileprivate func itemInfoForIndexPath(_ indexPath: IndexPath) -> CollectionViewItemInfo {
        let toViewState = itemFor(indexPath, inViewState: viewState)
        let component = componentProvider.componentFor(toViewState)
        let container = ReusableCollectionViewItemContainer(fromIndexPath: indexPath, toIndexPath: indexPath, collectionView: collectionView)

        return CollectionViewItemInfo(fromViewState: toViewState, toViewState: toViewState, component: component, container: container)
    }

    fileprivate func itemInfoForIndexPath(_ fromIndexPath: IndexPath, fromViewState: TempoSectionedViewState, toIndexPath: IndexPath) -> CollectionViewItemInfo {
        let fromViewState = itemFor(fromIndexPath, inViewState: fromViewState)
        let toViewState = itemFor(toIndexPath, inViewState: viewState)
        let component = componentProvider.componentFor(toViewState)
        let container = ReusableCollectionViewItemContainer(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath, collectionView: collectionView)

        return CollectionViewItemInfo(fromViewState: fromViewState, toViewState: toViewState, component: component, container: container)
    }

    fileprivate func itemFor(_ indexPath: IndexPath, inViewState viewState: TempoSectionedViewState) -> TempoViewStateItem {
        let section = viewState.sections[indexPath.section]

        if let items = section.items {
            return items[indexPath.item]
        } else {
            return section
        }
    }
    
    fileprivate func didFocus(_ indexPath: IndexPath, attributes: UICollectionViewLayoutAttributes) {
        let itemInfo = itemInfoForIndexPath(indexPath)
        itemInfo.focusAccessibility()
        itemInfo.didFocus(attributes.frame, coordinateSpace: collectionView)
    }
}

extension CollectionViewAdapter: SectionPresenterAdapter {
    public func applyUpdates(_ updates: [CollectionViewSectionUpdate], viewState: TempoSectionedViewState) {
        let fromViewState = self.viewState
        self.viewState = viewState

        guard !updates.isEmpty || collectionView.window == nil else {
            return
        }

        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .delete(let index):
                    self.deleteSection(index)
                case .insert(let index):
                    self.insertSection(index)
                case .reload(let index):
                    self.reloadSection(index)
                case .update(let fromIndex, let toIndex, let itemUpdates):
                    if itemUpdates.count > 0 {
                        self.updateSection(fromIndex, fromViewState: fromViewState, toSection: toIndex, itemUpdates: itemUpdates)
                    } else {
                        self.updateSection(fromIndex, fromViewState: fromViewState, toSection: toIndex)
                    }
                case .focus(let focus):
                    self.focus(focus)
                }
            }
        }, completion: nil)
    }
}

public struct ComponentWrapper<Cell> {
    var cell: Cell
    var view: UIView
}

public protocol ReusableViewContainer {
    func registerReusableView<T: UIView where T: Reusable>(_ viewType: T.Type)
    func registerReusableView<T: UIView where T: Reusable>(_ viewType: T.Type, reuseIdentifier: String)
}

public protocol ReusableViewItemContainer {
    associatedtype Cell

    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(_ viewType: T.Type) -> ComponentWrapper<Cell>
    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(_ viewType: T.Type, reuseIdentifier: String) -> ComponentWrapper<Cell>
    func visibleWrapper<T: UIView where T: Reusable>(_ viewType: T.Type) -> ComponentWrapper<Cell>?
}

public extension ReusableViewItemContainer {
    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(_ viewType: T.Type) -> ComponentWrapper<Cell> {
        return dequeueReusableWrapper(viewType, reuseIdentifier: viewType.reuseIdentifier)
    }
}

struct ReusableCollectionViewItemContainer: ReusableViewItemContainer {
    typealias Cell = UICollectionViewCell

    var fromIndexPath: IndexPath
    var toIndexPath: IndexPath
    var collectionView: UICollectionView
    
    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(_ viewType: T.Type, reuseIdentifier: String) -> ComponentWrapper<Cell> {
        let cell = collectionView.dequeueWrappedReusable(viewType, reuseIdentifier: reuseIdentifier, indexPath: toIndexPath)
        let componentWrapper = ComponentWrapper(cell: cell as Cell, view: cell.reusableView)
        return componentWrapper
    }

    func visibleWrapper<T: UIView where T: Reusable>(_ viewType: T.Type) -> ComponentWrapper<Cell>? {
        guard let cell = collectionView.cellForItem(at: fromIndexPath) as? CollectionViewWrapperCell<T> else {
            return nil
        }

        return ComponentWrapper(cell: cell, view: cell.reusableView)
    }
}

private struct CollectionViewItemInfo {
    let fromViewState: TempoViewStateItem
    let toViewState: TempoViewStateItem
    let component: ComponentType
    let container: ReusableCollectionViewItemContainer

    var view: UIView? {
        return component.visibleWrapper(container, viewState: fromViewState)?.view
    }

    var cell: UICollectionViewCell {
        let wrapper = component.dequeueWrapper(container, viewState: toViewState)
        component.willDisplayItem(toViewState)
        component.prepareView(wrapper.view, viewState: toViewState)
        component.configureView(wrapper.view, viewState: toViewState)
        return wrapper.cell
    }

    func configureView() {
        if let view = view {
            component.willDisplayItem(toViewState)
            component.configureView(view, viewState: toViewState)
        }
    }

    func focusAccessibility() {
        if let view = view {
            component.focusAccessibility(view, viewState: toViewState)
        }
    }
    
    func shouldHighlightView() -> Bool {
        if let view = view {
            return component.shouldHighlightView(view, viewState: toViewState)
        } else {
            return shouldSelectView()
        }
    }

    func shouldSelectView() -> Bool {
        if let view = view {
            return component.shouldSelectView(view, viewState: toViewState)
        } else {
            return true
        }
    }

    func selectView() {
        if let view = view, shouldSelectView() {
            component.selectView(view, viewState: toViewState)
        }
    }

    func didFocus(_ frame: CGRect, coordinateSpace: UICoordinateSpace) {
        component.didFocus(frame, coordinateSpace: coordinateSpace, viewState: toViewState)
    }
}

extension UICollectionView: ReusableViewContainer {
    public func registerReusableView<T: UIView where T: Reusable>(_ viewType: T.Type) {
        registerWrappedReusable(viewType)
    }

    public func registerReusableView<T: UIView where T: Reusable>(_ viewType: T.Type, reuseIdentifier: String) {
        registerWrappedReusable(viewType, reuseIdentifier: reuseIdentifier)
    }
}

extension CollectionViewAdapter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewState.sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewState.sections[section].numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return itemInfoForIndexPath(indexPath).cell
    }
}

extension CollectionViewAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemInfoForIndexPath(indexPath).selectView()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return itemInfoForIndexPath(indexPath).shouldHighlightView()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return itemInfoForIndexPath(indexPath).shouldSelectView()
    }
}

extension CollectionViewAdapter: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = focusingIndexPath {
            focusingIndexPath = nil

            if let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
                didFocus(indexPath, attributes: attributes)
            }
        }

        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewDelegate?.viewForZooming?(in: scrollView)
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
