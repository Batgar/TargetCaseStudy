//
//  ListItemViewState+SpecializedViewModels.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/11/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation
import UIKit

//This is a cheesy shortcut I threw into place to handle error cases.
//For a final product, this has to change, but for now, easy to do.

//Also is an extension so we can isolate this from the main - real - production
//level ListItemViewState

extension ListItemViewState {
    static func unavailable() -> ListItemViewState {
        return ListItemViewState(title: "No Deals Available", price: "0.00", image: UIImage(named:"0"), url:nil, aisle:"")
    }
}
