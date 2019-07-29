//  ServiceManager.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import AlamofireObjectMapper
import CoreLocation
import Alamofire
import SwiftyJSON
import GoogleMaps

class ServiceManager {
    
    static let get = ServiceManager()
    
    func requestPolyline(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, success:@escaping (GMSPolyline) -> Void, failure:@escaping (Error) -> Void ){
        
        let url = String(format: Constants.API_GOOGLE_URL_DIRECTIONS, origin.latitude, origin.longitude, destination.latitude, destination.longitude)
        
        Alamofire.request(url).responseObject {(response: DataResponse<Trip>) in
            if response.result.isSuccess {
                
                let json = try! JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    success(polyline)
                }
            }
            
            if response.result.isFailure {
                guard let error = response.result.error else { return }
                failure(error)
            }
        }
    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
