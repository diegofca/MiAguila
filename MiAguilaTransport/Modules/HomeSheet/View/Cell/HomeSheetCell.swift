//  TableViewCell.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import UIKit

class HomeSheetCell: UITableViewCell {
    
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var nameDriverLbl: UILabel!
    @IBOutlet weak var plateCarLbl: UILabel!
    @IBOutlet weak var statusTrip: UILabel!
    @IBOutlet weak var goRouteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setData(trip: Trip){
        destinationLbl.text = trip.end?.pickupAddress
        plateCarLbl.text = trip.car?.plate
        nameDriverLbl.text = "\(trip.driver?.firstName ?? "") \(trip.driver?.lastName ?? "")"
        statusTrip.text = trip.status?.uppercased()
    }
    
}
