//  RouteDetailViewController.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/28/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import UIKit
import CoreLocation
import GoogleMaps

class RouteDetailViewController: BaseViewController {
    
    //UI
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var updateUserLocationBtn: UIButton!
    @IBOutlet var showRouteLocationBtn: UIButton!
    @IBOutlet var startAddressLbl: UILabel!
    @IBOutlet var startTimeLbl: UILabel!
    @IBOutlet var endAddressLbl: UILabel!
    @IBOutlet var endTimeLbl: UILabel!
    
    @IBOutlet var daysViews: [UIView]!

    private let originMarker = MarketMap.instanceFromNib() as! MarketMap
    private let destinationMarker = MarketMap.instanceFromNib() as! MarketMap
    
    //data
    lazy var presenter: RouteDetailPresenter = {
        return RouteDetailPresenter()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        presenter.getTripDetailData()
    }
    
    func configViews(){
        setCustomNavigationBar()
        roundedDaysViews()
        mapView.delegate = self
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
        mapView.isMyLocationEnabled = true
        mapView.settings.zoomGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.scrollGestures = false
        updateUserLocationBtn.addAction(for: .touchUpInside) {
            self.presenter.goToMyLocation(self.mapView)
        }
        showRouteLocationBtn.addAction(for: .touchUpInside) {
            self.presenter.getTripDetailData()
        }
    }
    
    private func roundedDaysViews(){
        for view in daysViews {
            view.layer.cornerRadius = view.frame.height/2
        }
    }
    
    override func initReactData() {
        locationManager.delegate = self
        super.initReactData()
        
        presenter.listenerSelectedTrip = { [weak self] trip in
            guard let strSelf = self else { return }
            strSelf.mapView.clear()
            strSelf.originMarker.createMarker( trip, typeMarket: .Init, map: strSelf.mapView)
            strSelf.destinationMarker.createMarker( trip, typeMarket: .Destination, map: strSelf.mapView)
        }
        
        presenter.listenerStartAddress = { [weak self] address in
            guard let strSelf = self else { return }
            strSelf.startAddressLbl.text = address
        }
        
        presenter.listenerEndAddress = { [weak self] address in
            guard let strSelf = self else { return }
            strSelf.endAddressLbl.text = address
        }
        
        presenter.listenerStartTime = { [weak self] time in
            guard let strSelf = self else { return }
            strSelf.startTimeLbl.text = time
        }
        
        presenter.listenerEndTime = { [weak self] time in
            guard let strSelf = self else { return }
            strSelf.endTimeLbl.text = time
        }
        
        presenter.listenerPolylineSelectedTrip = { [weak self] polyline, camera in
            guard let strSelf = self else { return }
            strSelf.mapView.drawLinePolyline(polyline)
            strSelf.mapView.animate(with: camera)
        }
    }
    
    func setTripDetail(_ trip: Trip){
        presenter.setTripDetail(trip)
    }
}

extension RouteDetailViewController : GMSMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        presenter.setUserLocation(location: currentLocation)
    }
}
