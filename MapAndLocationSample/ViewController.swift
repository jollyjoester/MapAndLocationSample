//
//  ViewController.swift
//  MapAndLocationSample
//
//  Created by jollyjoester on 2022/01/29.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        
    }


}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let longitude = locations.last?.coordinate.longitude.description
        let latitude = locations.last?.coordinate.latitude.description
        print("longitude \(longitude)")
        print("latitude \(latitude)")
    }
}
