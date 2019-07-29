//  HomeViewController.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import UIKit
import CoreLocation
import GoogleMaps

class HomeViewController: BaseViewController {
    
    //UI
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var updateUserLocationBtn: UIButton!
    @IBOutlet var compassLocationBtn: UIButton!
    @IBOutlet var bottomContainerView: UIView!
    private weak var bottomSheet: HomeSheetViewController!
    
    private let originMarker = MarketMap.instanceFromNib() as! MarketMap
    private let destinationMarker = MarketMap.instanceFromNib() as! MarketMap
    private let infoWindowMarker = MarkerInfoCustomWindow.instanceFromNib() as! MarkerInfoCustomWindow
    
    //data
    lazy var presenter: HomePresenter = {
        return HomePresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        presenter.getRamdonTrip()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.isActiveCompass(force: false)
    }
    
    func configViews(){
        setCustomNavigationBar()
        bottomContainerView.setPrettyView()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
        mapView.settings.zoomGestures = true
        presenter.isActiveCompass(force: false)
        updateUserLocationBtn.addAction(for: .touchUpInside) {
            self.presenter.goToMyLocation(self.mapView)
        }
        compassLocationBtn.addAction(for: .touchUpInside) {
            self.presenter.isActiveCompass()
        }
    }
    
    override func initReactData() {
        locationManager.delegate = self
        super.initReactData()
        
        presenter.listenerTrip = { [weak self] tripList in
            guard let strSelf = self else { return }
            strSelf.bottomSheet.tripList = tripList
        }
        
        presenter.listenerSelectedTrip = { [weak self] trip in
            guard let strSelf = self else { return }
            strSelf.alertSuccess(trip.end?.pickupAddress ?? "")
            strSelf.mapView.clear()
            strSelf.originMarker.createMarker( trip, typeMarket: .Init, map: strSelf.mapView)
            strSelf.destinationMarker.createMarker( trip, typeMarket: .Destination, map: strSelf.mapView)
        }
        
        presenter.listenerAngleTrip = { [weak self] angle in
            guard let strSelf = self else { return }
            strSelf.mapView.animate(toViewingAngle: angle)
        }
        
        presenter.listenerPolylineSelectedTrip = { [weak self] polyline, camera in
            guard let strSelf = self else { return }
            strSelf.mapView.drawLinePolyline(polyline)
            strSelf.mapView.animate(with: camera)
        }
        
        presenter.listenerStatusCompass = {[weak self] colorBtn in
            guard let strSelf = self else { return }
            let image = strSelf.compassLocationBtn.imageView?.image?.withRenderingMode(.alwaysTemplate)
            strSelf.compassLocationBtn.setImage(image, for: .normal)
            strSelf.compassLocationBtn.tintColor = colorBtn
        }
        
        presenter.listenerError = { [weak self] error in
            guard let strSelf = self else { return }
            strSelf.alertError(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewSheetController = segue.destination as? HomeSheetViewController {
            viewSheetController.bottomSheetDelegate = self
            viewSheetController.parentView = bottomContainerView
            bottomSheet = viewSheetController
        }
        if let detailTripController = segue.destination as? RouteDetailViewController {
            if let data = sender as? [String:Any] {
                guard let trip = data["trip"] as? Trip else { return }
                detailTripController.setTripDetail(trip)
            }
        }
    }
}

extension HomeViewController : BottomSheetDelegate {
    func goRoute(_ trip: Trip) {
        var dictSendData : [String:Any] = [:]
        dictSendData.updateValue(trip, forKey: "trip")
        self.performSegue(withIdentifier: "routeDetailSegue", sender: dictSendData)
    }
    
    func updateBottomSheet(frame: CGRect) {
        bottomContainerView.frame = frame
    }
    
    func selectedTrip(_ trip: Trip) {
        presenter.selectedTrip(trip)
    }
}

extension HomeViewController : GMSMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        if presenter.userLocation == nil {
            presenter.setUserLocation(location: currentLocation)
            presenter.goToMyLocation(self.mapView)
        }
        presenter.setUserLocation(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard presenter.activeCompass else { return }
        mapView.animate(toBearing: newHeading.trueHeading)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        var dictSendData : [String:Any] = [:]
        guard let tripSelected = presenter.getCurrentTrip() else { return }
        dictSendData.updateValue(tripSelected, forKey: "trip")
        self.performSegue(withIdentifier: "routeDetailSegue", sender: dictSendData)
    }
 
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = MarkerInfoCustomWindow.instanceFromNib() as! MarkerInfoCustomWindow
        guard let tripSelected = presenter.getCurrentTrip() else { return nil }
        infoWindow.setData(tripSelected)
        return infoWindow
    }
    
}


