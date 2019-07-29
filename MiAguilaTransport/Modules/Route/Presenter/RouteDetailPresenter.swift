//  RouteDetailPresenter.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/28/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import CoreLocation
import GoogleMaps
import SwiftyJSON

class RouteDetailPresenter {
    
    //constans
    lazy var workerInteractor = RouteDetailInteractor()
    
    var listenerSelectedTrip: ((Trip)-> Void)?
    var listenerStartAddress: ((String) -> Void)?
    var listenerStartTime: ((String) -> Void)?
    var listenerEndAddress: ((String) -> Void)?
    var listenerEndTime: ((String) -> Void)?
    var listenerPolylineSelectedTrip: ((GMSPolyline,GMSCameraUpdate)-> Void)?
    var listenerAngleTrip: ((Double) -> Void)?
    
    var listenerError: ((Error) -> Void)?
    
    //variables
    var userLocation: CLLocation?
    var tripDetail: Trip?

    struct Constants {
        let entryLabel: String = "Entrada "
        let turnOffLabel: String = "Salida "
    }
    
    var constants = Constants()
    
    func setTripDetail(_ trip: Trip){
        tripDetail = trip
    }
    
    func setUserLocation(location: CLLocation) {
        userLocation = location
    }
    
    func goToMyLocation(_ mapView: GMSMapView){
        guard let location = userLocation?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: 17)
        mapView.animate(to: camera)
    }
    
    func getTripDetailData(){
        guard let trip = tripDetail else { return }
        listenerSelectedTrip?(trip)
        
        if let startAddress = trip.start?.pickupAddress {
            listenerStartAddress?(startAddress)
        }
        
        if let startTime = trip.start?.date {
            listenerStartTime?(constants.entryLabel + startTime.getHourString())
        }
        
        if let endAddress = trip.end?.pickupAddress {
            listenerEndAddress?(endAddress)
        }
        
        if let endTime = trip.end?.date {
            listenerEndTime?(constants.turnOffLabel + endTime)
        }
        
        workerInteractor.getPolylineTrip(trip: trip, success: { (polyline, camera) in
            self.listenerPolylineSelectedTrip?(polyline,camera)
        }) { (error) in
            self.listenerError?(error)
        }
    }
    
}
