//  HomePresenter.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import CoreLocation
import GoogleMaps

class HomePresenter {
    
    //constans
    lazy var workerInteractor = HomeInteractor()
    let zoom: Float = 17
    
    var listenerTrip: (([Trip])-> Void)?
    var listenerError: ((Error) -> Void)?
    var listenerSelectedTrip: ((Trip)-> Void)?
    var listenerPolylineSelectedTrip: ((GMSPolyline,GMSCameraUpdate)-> Void)?
    var listenerAngleTrip: ((Double) -> Void)?
    var listenerStatusCompass: ((UIColor) -> Void)?
    
    //variables
    var userLocation: CLLocation?
    var tripCurrentSelect: Trip?
    var activeCompass: Bool = false
    
    func getRamdonTrip(){
        workerInteractor.getTravel(userLocation: userLocation, success: { travels in
            self.listenerTrip?(travels)
        }) { error in
            self.listenerError?(error)
        }
    }
    
    func goToMyLocation(_ mapView: GMSMapView){
        guard let location = userLocation?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
        mapView.animate(to: camera)
    }
    
    func isActiveCompass(){
        activeCompass = !activeCompass
        let color: UIColor = activeCompass ? .primaryGreen() : .lightGray
        listenerStatusCompass?(color)
    }
    
    func isActiveCompass(force: Bool){
        activeCompass = force
        let color: UIColor = activeCompass ? .primaryGreen() : .lightGray
        listenerStatusCompass?(color)
    }
    
    func setUserLocation(location: CLLocation) {
        userLocation = location
    }
    
    func selectedTrip(_ trip: Trip) {
        tripCurrentSelect = trip
        drawerPolylineTrip(trip)
        listenerSelectedTrip?(trip)
    }
    
    func getCurrentTrip() -> Trip? {
        return tripCurrentSelect
    }
    
    private func calculateAngleTripMap(_ trip: Trip){
        let originCoor = workerInteractor.getOriginCoordinateByTrip(trip)
        let destinationCoor = workerInteractor.getDestinationCoordinateByTrip(trip)
        guard let origin = originCoor, let destination = destinationCoor else { return }
        let direction1 = origin.bearing(to: destination)
        let direction2 = destination.bearing(to: origin)
        listenerAngleTrip?(direction1 + direction2)
    }
    
    private func drawerPolylineTrip(_ trip: Trip) {
        workerInteractor.getPolylineTrip(trip: trip, success: { polyLine, camera in
            self.listenerPolylineSelectedTrip?(polyLine, camera)
        }) { error in
            self.listenerError?(error)
        }
    }
    
}
