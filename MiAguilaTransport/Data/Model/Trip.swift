//  Travel.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import ObjectMapper

class Trip : Mappable {
    
    var start: TripStart?
    var end : TripEnded?
    var country: Country?
    var city: City?
    var passenger: Passenger?
    var driver: Driver?
    var car: Car?
    var status: String?
    var checkCode: String?
    var createdAt: String?
    var updatedAt: String?
    var price: Double?
    var driverLocation: Location?
    
    init() {}
    func mapping(map: Map) {
        self.start     <- map["start"]
        self.end       <- map["end"]
        self.country   <- map["country"]
        self.city      <- map["city"]
        self.passenger <- map["passenger"]
        self.driver    <- map["driver"]
        self.car       <- map["car"]
        self.status    <- map["status"]
        self.checkCode <- map["check_code"]
        self.createdAt <- map["createdAt.$date"]
        self.updatedAt <- map["updatedAt.$date"]
        self.price     <- map["price"]
        self.driverLocation <- map["driver_location"]
    }
    required init (map: Map) {}
}

class TripStart: Mappable {
    
    var date: String?
    var pickupAddress: String?
    var location: Location?
    
    init() {}
    func mapping(map: Map) {
        self.date           <- map["date.$date"]
        self.pickupAddress  <- map["pickup_address"]
        self.location       <- map["pickup_location"]
    }
    required init (map: Map) {}
}

class TripEnded: Mappable {
    
    var date: String?
    var pickupAddress: String?
    var location: Location?
    
    init() {}
    func mapping(map: Map) {
        self.date          <- map["date.$date"]
        self.pickupAddress <- map["pickup_address"]
        self.location      <- map["pickup_location"]
    }
    required init (map: Map) {}
}

class TripslList: Mappable {
    
    var trips: [Trip]?
    
    init() {}
    func mapping(map: Map) {
        self.trips          <- map["trips"]
    }
    required init (map: Map) {}
}
