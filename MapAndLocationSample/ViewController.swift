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
    
    var locationInfoList: [LocationInfo] = []
    var currentLocation: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    private func addAnnotations(with locationInfoList: [LocationInfo]) {
        for locationInfo in locationInfoList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationInfo.coordinate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            annotation.title = dateFormatter.string(from: locationInfo.recordedAt)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    private func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }

    @IBAction func tappedRecord(_ sender: UIButton) {
        
        if let currentLocation = currentLocation {
            let locationInfo = LocationInfo(coordinate: currentLocation, recordedAt: Date())
            locationInfoList.append(locationInfo)
        }
    }
    
    @IBAction func tappedDisplayAnnotations(_ sender: UIButton) {
        self.addAnnotations(with: locationInfoList)
    }
    
    @IBAction func tappedDeleteAnnotations(_ sender: UIButton) {
        self.removeAnnotations()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation? = locations.last
        
        if let location = location {
            let coordinate = location.coordinate

            currentLocation = coordinate
            
            let longitude = coordinate.longitude
            let latitude = coordinate.latitude
            print("longitude \(longitude)")
            print("latitude \(latitude)")
            
            mapView.setCenter(coordinate, animated: true)
        }
    }
}
