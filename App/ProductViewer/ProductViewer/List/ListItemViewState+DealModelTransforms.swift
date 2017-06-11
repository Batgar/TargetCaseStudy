//
//  ListItemViewState+DealModelTransforms.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/11/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation
import UIKit

//Figured we should isolate initializing the ListItemViewState from
//the Deal / underlying Decodable model so we can isolate ListItemViewState
//in the future for tests or future framework or other uses.

extension ListItemViewState {
    
    static func initializeFromDealModel(_ deal : Deal) -> ListItemViewState {
        
        //This may be a placeholder image if there is no URL in deal.image....
        let image = UIImage(named:"0") //Default or 'error' image.
        
        //Since we are transforming from Decoded struct to the item view state here, we choose to do some data transforms (in this case the aisle getting upper cased.
        //We can have an extension to ListItemViewState that initializes it from the decoded struct from the service, but we are just taking
        //some shortcuts here due to the existing design that was in place.
        return ListItemViewState(title: deal.title, price: deal.price, image: image, url: deal.image, aisle:deal.aisle.uppercased())
    }
}
