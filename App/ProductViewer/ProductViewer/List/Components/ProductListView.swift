//
//  ProductListComponent.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit
import Tempo

final class ProductListView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var beforeAisleLabel: UILabel!
    @IBOutlet weak var aisleLabel: UILabel!
}

extension ProductListView: ReusableNib {
    @nonobjc static let nibName = "ProductListView"
    @nonobjc static let reuseIdentifier = "ProductListViewIdentifier"

    @nonobjc func prepareForReuse() {
        
    }
}
