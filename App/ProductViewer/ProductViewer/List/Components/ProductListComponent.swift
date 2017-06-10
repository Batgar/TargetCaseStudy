//
//  ProductListComponent.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ProductListComponent: Component {
    var dispatcher: Dispatcher?

    func prepareView(_ view: ProductListView, item: ListItemViewState) {
        // Called on first view or ProductListView
        
        
        //Initialize our rounded rect for the cell.
        // corner radius
        view.layer.cornerRadius = 10
        
        // border
        view.layer.borderWidth = 1.0
        view.layer.borderColor = HarmonyColor.targetNeutralGrayColor.cgColor

        
    }
    
    func configureView(_ view: ProductListView, item: ListItemViewState) {
        view.titleLabel.text = item.title
        view.priceLabel.text = item.price
        
        if let imageURL = item.url {
            UIImage.loadFromURL(url: imageURL) {
                asyncLoadedImage in
                DispatchQueue.main.async {
                    //This may replace any place holder image loaded below.
                    view.productImage.image = asyncLoadedImage
                }
            }
        }
        
        //No matter what load a possible place holder image given to us...
        //It may get overwritten by the above completion handler for an async image load, but that is OK.
        view.productImage.image = item.image
        
        //https://stackoverflow.com/a/19443609
        view.aisleLabel.text = item.aisle
        
        view.aisleLabel.layer.cornerRadius = view.aisleLabel.bounds.size.height / 2
        view.aisleLabel.layer.borderWidth = 1.0
        view.aisleLabel.layer.borderColor = HarmonyColor.targetNeutralGrayColor.cgColor
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string:"ship", attributes:[NSForegroundColorAttributeName : HarmonyColor.targetJetBlackColor]))
        attributedString.append(NSAttributedString(string:" or", attributes: [NSForegroundColorAttributeName:HarmonyColor.targetNeutralGrayColor]))
        view.beforeAisleLabel.attributedText = attributedString
        
    
    }
    
    func selectView(_ view: ProductListView, item: ListItemViewState) {
        dispatcher?.triggerEvent(ListItemPressed(item:item))
    }
}

extension ProductListComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 120.0
    }
}
