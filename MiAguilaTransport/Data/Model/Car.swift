//  Cart.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import ObjectMapper

class Car: Mappable {
    
    var plate: String?
    
    init() {}
    func mapping(map: Map) {
        self.plate <- map["plate"]
    }
    required init (map: Map) {}
}
