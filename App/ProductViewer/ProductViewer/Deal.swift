//
//  Deal.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation
import Decodable

public struct Deal {
    public let Id : String
    public let aisle : String
    public let description : String
    public let guid : String
    public let image : URL?
    public let index : Int
    public let price : String
    public let salePrice : String?
    public let title : String
}

extension Deal : Decodable {
    public static func decode(_ j : Any) throws -> Deal {
        return try Deal(Id: j => "_id",
                        aisle: j => "aisle",
                        description: j => "description",
                        guid: j => "guid",
                        image: URL(string: j => "image"),
                        index: j => "index",
                        price: j => "price",
                        salePrice: j =>? "salePrice",
                        title: j => "title")
    }
}

/*
 {
 "_id": "548917fabeb9b0cadc529af3",
 "aisle": "b2",
 "description": "minim ad et minim ipsum duis irure pariatur deserunt eu cillum anim ipsum velit tempor eu pariatur sunt mollit tempor ut tempor exercitation occaecat ad et veniam et excepteur velit esse eu et ut ipsum consectetur aliquip do quis voluptate cupidatat eu ut consequat adipisicing occaecat adipisicing proident laborum laboris deserunt in laborum est anim ad non",
 "guid": "f78e1c4d-93c5-4b92-ae47-7ea26be48c7c",
 "image": "http://lorempixel.com/400/400/",
 "index": 0,
 "price": "$184.06",
 "salePrice": null,
 "title": "non mollit veniam ex"
 }
 */
