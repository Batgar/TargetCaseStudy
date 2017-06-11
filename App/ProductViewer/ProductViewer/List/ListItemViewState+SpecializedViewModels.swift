//
//  ListItemViewState+SpecializedViewModels.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/11/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation
import UIKit

extension ListItemViewState {
    static func unavailable() -> ListItemViewState {
        return ListItemViewState(title: "No Deals Available", price: "0.00", image: UIImage(named:"0"), url:nil, aisle:"")
    }
}
