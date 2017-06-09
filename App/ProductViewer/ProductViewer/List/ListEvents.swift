//
//  ListEvents.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/19/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ListItemPressed: EventType {
    let item : ListItemViewState
}

//Added by Dan Edgar to handle item async loading.
struct ListItemReady: EventType {}
