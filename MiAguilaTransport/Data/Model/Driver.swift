//  Driver.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import ObjectMapper

class Driver: Mappable {
    
    var firstName: String?
    var lastName: String?
    
    init() {}
    func mapping(map: Map) {
        self.firstName <- map["first_name"]
        self.lastName  <- map["last_name"]
    }
    required init (map: Map) {}
}
