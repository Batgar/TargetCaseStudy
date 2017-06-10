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
    
    init (detailViewController : DetailViewController,
          dispatcher: Dispatcher) {
        self.detailViewController = detailViewController
        self.dispatcher = dispatcher
        
        detailViewController.addToCartButton.layer.cornerRadius = 5
        detailViewController.addToCartButton.clipsToBounds = true
        
        detailViewController.addToListButton.layer.cornerRadius = 5
        detailViewController.addToCartButton.clipsToBounds = true
        
        detailViewController.navigationController?.navigationBar.tintColor = UIColor.targetStarkWhiteColor
    }
    
    var detailViewController : DetailViewController
    
    func present(_ viewState: DetailViewState) {
        detailViewController.priceLabel.text = viewState.itemViewState.price
        
        detailViewController.navigationItem.title = viewState.itemViewState.title
        
        if let imageURL = viewState.itemViewState.url {
            UIImage.loadFromURL(url: imageURL) {
                image in
                DispatchQueue.main.async {
                    self.detailViewController.itemImage.image = image
                }
            }
        }
        
    }
}
