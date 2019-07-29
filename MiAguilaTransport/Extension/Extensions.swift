//  File.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import CoreLocation
import UIKit
import GoogleMaps

extension CLLocation {
    static func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    static func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
}

extension UIView {
    func setPrettyView(cornerRadius: CGFloat = 15){
        self.layer.cornerRadius = 15
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
}

extension GMSMapView {
    func drawLinePolyline(_ polyline: GMSPolyline){
        let strokeStyles = [GMSStrokeStyle.solidColor(.black), GMSStrokeStyle.solidColor(.clear)]
        let strokeLengths = [NSNumber(value: 10), NSNumber(value: 10)]
        if let path = polyline.path {
            polyline.spans = GMSStyleSpans(path, strokeStyles, strokeLengths, .rhumb)
            polyline.geodesic = true
        }
        polyline.map = self
    }
}

extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
        
        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)
        let lat2 = degreesToRadians(point.latitude)
        let lon2 = degreesToRadians(point.longitude)
        
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        return radiansToDegrees(radiansBearing)
    }
}

extension String {
    func getHourString( ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let date = formatter.date(from: self)
        return formatter.string(from: date ?? Date())
    }
}
