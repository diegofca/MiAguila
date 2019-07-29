//  Location.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import ObjectMapper
import CoreLocation

class Location: Mappable {
    
    var type: String?
    var coordinates: [Double]?
    var coorPoint: CLLocation!
    
    init() {}
    func mapping(map: Map) {
        self.type        <- map["type"]
        self.coordinates <- map["coordinates"]
        self.coorPoint    = CLLocation(latitude: self.coordinates?[1] ?? 0, longitude: self.coordinates?[0] ?? 0)
    }
    required init (map: Map) {}
}
