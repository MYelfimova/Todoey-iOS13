//
//  Item.swift
//  Todoey
//
//  Created by Maria Yelfimova on 25/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
//    init(titleString: String, doneBool: Bool) {
//        title = titleString
//        done = doneBool
//    }
}


