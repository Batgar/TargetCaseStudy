//
//  ListCoordinator.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation
import Tempo

/*
 Coordinator for the product list
 */
class ListCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: ListViewState {
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
    
    lazy var viewController: ListViewController = {
        return ListViewController.viewControllerFor(coordinator: self)
    }()
    
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        updateState()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item selected!", message: "🐶", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateState() {
        
        //Async load items as JSON. When items are available, then trigger that the items are ready via the
        //dispatcher, so the subscribed view can update.
        
        DealModelLoader.loadDeals {
            dealRoot in
        
            DispatchQueue.main.async {
                
                if dealRoot.isEmpty {
                    self.viewState.listItems = [
                        ListItemViewState(title: "No Deals Available", price: "0.00", image: UIImage(named:"0"), url:nil, aisle:"")
                    ]
                    return
                }
                
                guard let deals = dealRoot.deals else {
                    self.viewState.listItems = [
                        ListItemViewState(title: "No Deals Available", price: "0.00", image: UIImage(named:"0"), url:nil, aisle:"")
                    ]
                    return
                }
                
                if deals.count <= 0 {
                    self.viewState.listItems = [
                        ListItemViewState(title: "No Deals Available", price: "0.00", image: UIImage(named:"0"), url:nil, aisle:"")
                    ]
                    return
                }
                
                //Yes! We have valid deals! Woo hoo! Process them as best we can into list view items...
                //Someday: Async load that image per item so we don't wait around for them!
                
                self.viewState.listItems = deals.map { deal in
                    
                    //This may be a placeholder image if there is no URL in deal.image....
                    let image = UIImage(named:"0") //Default or 'error' image.
                    
                    return ListItemViewState(title: deal.title, price: deal.price, image: image, url: deal.image, aisle:deal.aisle.uppercased())
                }
                
                self.dispatcher.triggerEvent(ListItemReady())
                
                self.updateUI()
            }
        }
    }
}
