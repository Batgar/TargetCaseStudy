//
//  DevailViewPresenter.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Tempo

class DetailViewPresenter : TempoPresenter {
    
    var dispatcher: Dispatcher?
    
    init (detailView : ProductDetailView,
          dispatcher: Dispatcher) {
        self.detailView = detailView
        self.dispatcher = dispatcher
    }
    
    var detailView : ProductDetailView
    
    func present(_ viewState: DetailViewState) {
        detailView.priceLabel.text = viewState.itemViewState.price
        
        
    }
}
