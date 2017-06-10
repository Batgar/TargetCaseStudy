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
        registerListeners()
        updateState()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            
            
            let detailCoordinator = DetailCoordinator(incomingViewState: e.item)
            //self?.viewController.present(detailCoordinator.viewController, animated:true, completion:nil)
            
            //We are going to push and keep the nav bar visible.
            self?.viewController.navigationController?.pushViewController(detailCoordinator.viewController, animated: true)
        }
        
        dispatcher.addObserver(DealsLoadingStart.self) { [weak self] e in
            //Start showing the activity indicator on this view.
            self?.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            
            self?.activityIndicator?.color = UIColor.targetJetBlackColor
            
            self?.activityIndicator!.startAnimating()
            
            self?.activityIndicator!.isHidden = false
            
            self?.activityIndicator!.center = (self?.viewController.view.center)!
            
            self?.viewController.view.addSubview((self?.activityIndicator)!)
        }
        
        dispatcher.addObserver(DealsLoadingEnd.self) { [weak self] e in
            //End showing the activity indicator on this view.
            if let activityIndicator = self?.activityIndicator {
                activityIndicator.removeFromSuperview()
                self?.activityIndicator = nil
            }
        }
    }
    
    var activityIndicator : UIActivityIndicatorView?
    
    func updateState() {
        
        //Async load items as JSON. When items are available, then trigger that the items are ready via the
        //dispatcher, so the subscribed view can update.
        //Before we update the state, we should let the presenter know that we may want
        //to show an activity indicator.
        
        //This may be over kill because the handler is also in this class but...
        //you never know when you may want to move the handler to somewhere else.
        dispatcher.triggerEvent(DealsLoadingStart())
        
        
        //Delay this by 10 seconds to test the activity indicator view.
        //DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        
        DealModelLoader.loadDeals {
            dealRoot in
        
            DispatchQueue.main.async {
                
                self.dispatcher.triggerEvent(DealsLoadingEnd())
                
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
        //} -- 10 second delay test uncomment out.
    }
}
