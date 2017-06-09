//
//  UIImage+AsyncImageLoad.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    // Loads image asynchronously
    class func loadFromURL(url: URL, callback: @escaping (UIImage)->()) {
        DispatchQueue.global(qos: .default).async {
            
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: imageData) {
                        callback(image)
                    }
                }
            }
        }
    }
}
