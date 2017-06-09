//
//  DetailCoordinator.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//



import Foundation
import Tempo
import NYTPhotoViewer

/*
 Coordinator for the product list
 */
class DetailCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: DetailViewState {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: UIViewController = {
        return DetailViewController.viewControllerFor(coordinator: self)
    }()
    
    // MARK: Init
    
    required init(incomingViewState : ListItemViewState) {
        viewState = DetailViewState(itemViewState : incomingViewState)
        updateUI()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(AddToCartPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item added to cart!", message: "🐶", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.viewController.present(alert, animated: true, completion: nil)
        }
        
        dispatcher.addObserver(AddToListPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item added to list!", message: "🐶", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.viewController.present(alert, animated: true, completion: nil)
        }
        
        dispatcher.addObserver(BlowUpImage.self) { [weak self] e in
            
            let productImages = e.images.map{ProductPhoto(image:$0, attributedCaptionTitle: NSAttributedString(string:""))}
                
            let photosViewController =
                    NYTPhotosViewController(photos:productImages)
            
            self?.viewController.present(photosViewController,  animated: true, completion: nil)
        }
    }
}
