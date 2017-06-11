//
//  DetailViewState+FromListItemViewState.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/11/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation

//Figured that this should be a separate extension just in case
//we want to isolate future DetailView pieces from this application / 
//list view dependency.

extension DetailViewState {
    
    
    static func initFromListItemViewState(_ listItemViewState : ListItemViewState) -> DetailViewState {
        
    return DetailViewState(price : listItemViewState.price,
        title: listItemViewState.title,
        url : listItemViewState.url)
    
    }
}
