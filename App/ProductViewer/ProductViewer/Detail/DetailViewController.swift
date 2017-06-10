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
    
    class func viewControllerFor(coordinator: TempoCoordinator) -> UINavigationController {
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
        
        
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let detailViewController = navigationController.viewControllers[0] as! DetailViewController
        
        detailViewController.coordinator = coordinator as? DetailCoordinator
        
        return navigationController
    }
    
    fileprivate var coordinator: DetailCoordinator!
    
    @IBOutlet weak var priceLabel: UILabel!
   
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var addToListButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Done", style:.done, target:self, action:#selector(dismissModal) )
        
        coordinator.presenters = [DetailViewPresenter(detailViewController:self,
                                                      dispatcher:coordinator.dispatcher)]
        
    }
    
    func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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

