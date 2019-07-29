//  MarkerInfoCustomWindow.swift
//  MiAguilaTransport
//
//  Created by Medios Digitales on 7/28/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

class MarkerInfoCustomWindow : UIView {
    
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ trip: Trip){
        priceLbl.text = "$ \(trip.price ?? 0)"
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MarkerInfoCustomWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
