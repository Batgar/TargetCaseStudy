//
//  ProductPhoto.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/9/17.
//  Copyright © 2017 Target. All rights reserved.
//

import UIKit
import NYTPhotoViewer
import Tempo

@objc class ProductPhoto : NSObject, NYTPhoto {
    
    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    var attributedCaptionSummary: NSAttributedString? = NSAttributedString(string: "summary string", attributes: [NSForegroundColorAttributeName: HarmonyColor.targetFadeAwayGrayColor])
    let attributedCaptionCredit: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: HarmonyColor.targetNeutralGrayColor])
    
    init(image: UIImage? = nil, imageData: Data? = nil, attributedCaptionTitle: NSAttributedString? = nil, attributedCaptionSummary : NSAttributedString? = nil) {
        self.image = image
        self.imageData = imageData
        self.attributedCaptionTitle = attributedCaptionTitle
        self.attributedCaptionSummary = attributedCaptionSummary
        super.init()
    }
    
}
