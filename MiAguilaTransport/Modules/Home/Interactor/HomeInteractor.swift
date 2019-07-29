//  HomeInteractor.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import CoreLocation
import SwiftyJSON
import GoogleMaps

class HomeInteractor {
    
    private let serviceManager = ServiceManager.get
    private let localManager = LocalManager.get
    
    func getTravel(userLocation: CLLocation?, success:@escaping ([Trip]) -> Void, failure:@escaping (Error) -> Void ){
        localManager.getTravelsbyJSON( success: { (travelsList) in
            let cityTrips = travelsList.filter({ $0.city?.name == "Bogotá"})
            let tripsShuffled = Array(cityTrips.shuffled().prefix(5))
            let closenessTrips = tripsShuffled.sorted(by: { (tripInit, tripSq) -> Bool in
                guard let distanceInit = userLocation?.distance(from: (tripInit.start?.location?.coorPoint)!) else { return false }
                guard let distanceSq = userLocation?.distance(from: (tripSq.start?.location?.coorPoint)!) else { return false }
                if distanceInit > distanceSq {
                    return true
                }
                return false
            })
            success(closenessTrips)
        }) { (error) in
            failure(error)
        }
    }
    
    func getDestinationCoordinateByTrip(_ trip: Trip) -> CLLocationCoordinate2D? {
        guard let destination = trip.end?.location?.coorPoint.coordinate else { return nil }
        return destination
    }
    
    func getOriginCoordinateByTrip(_ trip: Trip) -> CLLocationCoordinate2D? {
        guard let origin = trip.start?.location?.coorPoint.coordinate else { return nil }
        return origin
    }
    
    func getPolylineTrip(trip: Trip, success:@escaping (GMSPolyline, GMSCameraUpdate) -> Void, failure:@escaping (Error) -> Void ){
        guard let origin = trip.start?.location?.coorPoint.coordinate else { return }
        guard let destination = trip.end?.location?.coorPoint.coordinate else { return }
        serviceManager.requestPolyline(origin: origin, destination: destination, success: { polyline in
            let bounds = GMSCoordinateBounds(path: polyline.path!)
            let camera = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
            success(polyline, camera)
        }, failure: failure)
    }
    
}

