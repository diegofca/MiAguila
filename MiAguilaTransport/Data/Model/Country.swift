//  Country.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import ObjectMapper

class Country: Mappable {
    
    var name: String?
    
    init() {}
    func mapping(map: Map) {
        self.name <- map["name"]
    }
    required init (map: Map) {}
}
