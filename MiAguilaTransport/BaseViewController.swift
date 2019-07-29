//
//  ViewController.swift
//  MiAguilaTransport
//
//  Created by Medios Digitales on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.
//

import UIKit
import CoreLocation
import AlertBar

class BaseViewController: UIViewController {
    
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initReactData()
    }
    
    func initReactData(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType = .automotiveNavigation;
    }
    
    func alertSuccess(_ text:String){
        createAlert(text, type: .custom(.primaryGreen(), .white))
    }
    
    func alertInfo(_ text:String){
        createAlert(text, type: .info)
    }
    
    func alertError(_ text:String){
        createAlert(text, type: .error)
    }
    
    private func createAlert(_ text:String, type: AlertBarType){
        let options = AlertBar.Options(
            shouldConsiderSafeArea: true,
            isStretchable: true,
            textAlignment: .center
        )
        AlertBar.show(type: type , message: text, options: options)
    }
    
    func setCustomNavigationBar(){
        let yourBackImage = UIImage(named: "ic_back_bar")?.withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = .primaryGreen()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .white

        
    }

    
}
