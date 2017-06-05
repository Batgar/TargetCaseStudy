//
//  ProductDetailView.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//


import UIKit
import Tempo

final class ProductDetailView: UIView {
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var itemImage: UIImageView!
    
}

/*extension ProductDetailView: ReusableView {
    @nonobjc static let nibName = "ProductDetailView"
    @nonobjc static let reuseIdentifier = "ProductDetailViewIdentifier"
    
    @nonobjc func prepareForReuse() {
        
    }
}*/
