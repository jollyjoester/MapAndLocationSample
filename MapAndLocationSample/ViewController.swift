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

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true

    }


}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation? = locations.last
        
        if let location = location {
            let coordinate = location.coordinate

            let longitude = coordinate.longitude
            let latitude = coordinate.latitude
            print("longitude \(longitude)")
            print("latitude \(latitude)")
            
            mapView.setCenter(coordinate, animated: true)
            
        }
    }
}
