//
//  DetailViewController.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//


import UIKit
import Tempo

class DetailViewController: UIViewController {
    
    class func viewControllerFor(coordinator: TempoCoordinator) -> UIViewController {
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
        
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        
        detailViewController.coordinator = coordinator as? DetailCoordinator
        
        return detailViewController
    }
    
    fileprivate var coordinator: DetailCoordinator!
    
    @IBOutlet weak var priceLabel: UILabel!
   
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var addToListButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator.presenters = [DetailViewPresenter(detailViewController:self,
                                                      dispatcher:coordinator.dispatcher)]
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func addToListTouchUpInside(_ sender: Any) {
        coordinator.dispatcher.triggerEvent(AddToListPressed())
    }
    
    @IBAction func addToCartTouchUpInside(_ sender: Any) {
        coordinator.dispatcher.triggerEvent(AddToCartPressed())
    }
    
    @IBAction func tapImage(_ sender: Any) {
        if let itemImage = itemImage.image {
            coordinator.dispatcher.triggerEvent(BlowUpImage(image: itemImage))
        }
    }
}

