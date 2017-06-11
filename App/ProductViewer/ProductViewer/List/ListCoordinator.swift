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
           
            
            //We are going to push and keep the nav bar visible.
            self?.viewController.navigationController?.pushViewController(detailCoordinator.viewController, animated: true)
            
            //Modal / popup alternative.
             //self?.viewController.present(detailCoordinator.viewController, animated:true, completion:nil)
        }
        
        dispatcher.addObserver(DealsLoadingStart.self) { [weak self] e in
            
            self?.viewController.showActivityIndicator()
        }
        
        dispatcher.addObserver(DealsLoadingEnd.self) { [weak self] e in
            //End showing the activity indicator on this view when the deals are done loading.
            
            self?.viewController.hideActivityIndicator()
        }
    }
    
    func updateState() {
        
        //Async load items as JSON from web service. 
        //When items are available, then trigger that the items are ready via the
        //dispatcher, so the subscribed view can update.
        //Before we update the state, we should let the presenter know that we may want
        //to show an activity indicator.
        
        //This may be over kill because the handler is also in this class but...
        //you never know when you may want to move the handler to somewhere else.
        
        //I also assume that in the future multiple clients may want want to know
        //when the async task starts / stops for DealsLoadingStart / DealsLoadingFinish
        dispatcher.triggerEvent(DealsLoadingStart())
        
        
        //Delay this by 10 seconds to test the activity indicator view.
        //DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        
        DealModelLoader.loadDeals {
            dealRoot in
        
            DispatchQueue.main.async {
                
                self.dispatcher.triggerEvent(DealsLoadingEnd())
                
                if dealRoot.isEmpty {
                    self.viewState.listItems = [
                        ListItemViewState.unavailable()
                    ]
                    return
                }
                
                guard let deals = dealRoot.deals else {
                    self.viewState.listItems = [
                        ListItemViewState.unavailable()
                    ]
                    return
                }
                
                if deals.count <= 0 {
                    self.viewState.listItems = [
                        ListItemViewState.unavailable()
                    ]
                    return
                }
                
                //Yes! We have valid deals! Woo hoo! Process the 'decoded' structs 
                //as best we can into list view items.
                
                //Long term, since we have structs here, it isn't a big deal to just send on the struct instead of processing out each member.
                
                self.viewState.listItems = deals.map { deal in
                    
                    //Route to a specialized extension to init the view state (or view model) from the deal (or model)
                   return ListItemViewState.initializeFromDealModel(deal)
                
                }
                
                self.updateUI()
            }
        }
        //} -- 10 second delay test uncomment out.
    }
}
