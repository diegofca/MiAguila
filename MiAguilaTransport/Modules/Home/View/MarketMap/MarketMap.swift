//  MarketMap.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

enum TypeMarker {
    case Init
    case Destination
}

class MarketMap: UIView {
    
    @IBOutlet weak var addressInitLabel: UILabel!
    @IBOutlet weak var addressDestinationLabel: UILabel!
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var destinationView: UIView!
    
    func createMarker(_ trip: Trip?, typeMarket: TypeMarker, map: GMSMapView) {
        guard let currentLocation = typeMarket == .Init ? trip?.start?.location?.coorPoint.coordinate : trip?.end?.location?.coorPoint.coordinate else { return }
        let marker = GMSMarker(position: currentLocation)
        switch typeMarket {
        case .Destination:
            addressDestinationLabel.text = trip?.end?.pickupAddress ?? "Inicio"
            destinationView.isHidden = false
        default:
            addressInitLabel.text = trip?.start?.pickupAddress ?? "Destino"
            initView.isHidden = false
        }
        marker.iconView = self
        marker.map = map
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MarketMap", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
