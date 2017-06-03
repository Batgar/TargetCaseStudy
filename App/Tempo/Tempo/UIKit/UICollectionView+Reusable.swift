//
//  UICollectionView+HarmonyKit.swift
//  HarmonyKit
//
//  Created by Erik.Kerber on 11/17/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public enum DifferenceType {
    case insert
    case delete
}

public protocol SectionIndexDifferenceType {
    var differenceType: DifferenceType { get }
    var sectionsForDifference: IndexSet { get }
    var sectionsForReload: IndexSet { get }
}

public protocol SectionAndRowIndexDifferenceType {
    var freshLoad: Bool { get }
    
    var deletedSections: IndexSet { get }
    var addedSections: IndexSet { get }
    var reloadSections: IndexSet { get }
    
    var deletedRows: [IndexPath] { get }
    var addedRows: [IndexPath] { get }
    var reloadRows: [IndexPath] { get }
}

public protocol SelectionDifferenceType {
    var itemsToSelect: [IndexPath] { get }
    var itemsToDeselect: [IndexPath] { get }
}

extension UICollectionView {
    func update(_ difference: SectionIndexDifferenceType, completion: ((Bool) -> Void)? = nil) {
        performBatchUpdates({
            switch difference.differenceType {
            case .insert:
                self.insertSections(difference.sectionsForDifference)
            case .delete:
                self.deleteSections(difference.sectionsForDifference)
            }
            UIView.performWithoutAnimation {
                self.performBatchUpdates({
                    self.reloadSections(difference.sectionsForReload)
                    }) {success in }
            }
        }) {success in

            completion?(success)
        }
        
    }
    
    func update(_ difference: SectionAndRowIndexDifferenceType, completion: ((Bool) -> Void)? = nil) {
        
        #if DEBUG
        print("SECTION ADD: \(difference.addedSections)")
        print("SECTION DELETE: \(difference.deletedSections)")
        print("SECTION RELOAD: \(difference.reloadSections)")
        
        print("ROW ADD: \(difference.addedRows)")
        print("ROW DELETE: \(difference.deletedRows)")
        print("ROW RELOAD: \(difference.reloadRows)")
        #endif
        
        performBatchUpdates({

            // Sections
            self.insertSections(difference.addedSections)
            self.deleteSections(difference.deletedSections)
            self.reloadSections(difference.reloadSections)

            // Rows
            self.insertItems(at: difference.addedRows)
            self.deleteItems(at: difference.deletedRows)

        }) { success in

            // Just reload individual items after the batch.
            // The animations are... really bad otherwise ¯\_(ツ)_/¯.
            self.reloadItems(at: difference.reloadRows)

            // Did they add a section or a row? Scroll to it.
            if difference.freshLoad {
                // Do nothing if this is the first load -lest we always scroll of the top on first run!
            } else if difference.addedSections.count > 0 {
                self.scrollToItem(at: IndexPath(item: 0, section: difference.addedSections.first!), at: .top, animated: true)
            } else if let firstItem = difference.addedRows.first {
                self.scrollToItem(at: firstItem, at: .top, animated: true)
            }
            completion?(success)
        }
        
    }
    
    func update(_ selectionData: SelectionDifferenceType) {
        #if DEBUG
        print("SELECTION ADD: \(selectionData.itemsToSelect)")
        print("SELECTION REMOVE: \(selectionData.itemsToDeselect)")
        #endif

        UIView.performWithoutAnimation {
            selectionData.itemsToSelect.forEach {
                self.selectItem(at: $0, animated: false, scrollPosition: UICollectionViewScrollPosition())
            }
            
            selectionData.itemsToDeselect.forEach {
                self.deselectItem(at: $0, animated: false)
            }
        }
    }
}

/// Strongly typed collection view cell dequeueing
public extension UICollectionView {
    
    /// Register a class based cell
    public func registerReusable(_ cellClass: Reusable.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// Register a nib based cell
    public func registerReusable(_ cellClass: ReusableNib.Type) {
        register(UINib(nibName: cellClass.nibName, bundle: Bundle(for: cellClass)), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    /// Register wrapped nib based cell
    public func registerWrappedReusable<T: UIView where T: Reusable>(_ viewType: T.Type) {
        registerWrappedReusable(viewType, reuseIdentifier: viewType.reuseIdentifier)
    }

    /// Register wrapped nib based cell with a custom reuse identifier
    public func registerWrappedReusable<T: UIView where T: Reusable>(_ viewType: T.Type, reuseIdentifier: String) {
        register(CollectionViewWrapperCell<T>.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // Safely dequeue a `Reusable` item
    public func dequeueReusable<T where T: Reusable, T: UICollectionViewCell>(_ cellType: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: (cellType as! UICollectionViewCell).reuseIdentifier!, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellType)!")
        }
        
        return cell
    }

    // Safely dequeue a `Reusable` item with a custom reuse identifier
    public func dequeueReusable<T: UICollectionViewCell where T: Reusable>(_ cellType: T.Type, reuseIdentifier: String, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellType)!")
        }

        return cell
    }
}

/// Dequeuing mechanism for CollectionViewWrapperCell
public extension UICollectionView {

    public func dequeueWrappedReusable<T: UIView where T: Reusable, T: Creatable>(_ viewType: T.Type, indexPath: IndexPath) -> CollectionViewWrapperCell<T> {
        return dequeueWrappedReusable(viewType, reuseIdentifier: viewType.reuseIdentifier, indexPath: indexPath)
    }

    public func dequeueWrappedReusable<T: UIView where T: Reusable, T: Creatable>(_ viewType: T.Type, reuseIdentifier: String, indexPath: IndexPath) -> CollectionViewWrapperCell<T> {
        let cell = dequeueReusable(CollectionViewWrapperCell<T>.self, reuseIdentifier: reuseIdentifier, indexPath: indexPath)
        
        if cell.reusableView == nil {
            cell.reusableView = T.create()
        }
        
        return cell
    }
}

/// UICollectionViewCell designed to wrap an arbitrary view inside of it.
open class CollectionViewWrapperCell<T: UIView where T: Reusable>: HarmonyCellBase, Reusable {
    
    // Static stored properties "not yet supported in Swift" 💁🏼
    open static var reuseIdentifier: String {
        return T.reuseIdentifier
    }
    
    // The private setter makes the IUO easier to swallow.
    open fileprivate(set) var reusableView: T! {
        willSet {
            reusableView?.removeFromSuperview()
        }
        didSet {
            reusableView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addAndPinSubviewToMargins(reusableView)
        }
    }
        
    override open func prepareForReuse() {
        super.prepareForReuse()
        reusableView.prepareForReuse()
        setNeedsLayout()
    }
}
