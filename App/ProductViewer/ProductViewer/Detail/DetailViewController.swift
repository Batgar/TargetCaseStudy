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
        let viewController = DetailViewController()
        viewController.coordinator = coordinator
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
    
    fileprivate var coordinator: TempoCoordinator!
    
    lazy var productDetailView: ProductDetailView = {
        return UIView.fromNib()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Done", style:.done, target:self, action:#selector(dismissModal) )
        
        view.addAndPinSubview(productDetailView)
        
        coordinator.presenters = [DetailViewPresenter(detailView:self.productDetailView,
                                                      dispatcher:coordinator.dispatcher)]
        
    }
    
    func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}

