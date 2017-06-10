//
//  DetailViewEvents.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Tempo

struct AddToCartPressed: EventType {}

//Added by Dan Edgar to handle item async loading.
struct AddToListPressed: EventType {}

struct BlowUpImage: EventType {
    let image : UIImage
}
