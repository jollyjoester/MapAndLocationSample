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
    var userLocationLogs: [CLLocationCoordinate2D] = []
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        // 現在地と表示する領域の広さ等を設定
        mapView.showsUserLocation = true
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
        mapView.region = region
    }
    
    private func addAnnotations(with locationInfoList: [LocationInfo]) {
        
        // いったん全部のAnnotationを削除
        mapView.removeAnnotations(mapView.annotations)
        
        // 記録してある位置情報ごとにAnnotationを追加
        for locationInfo in locationInfoList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationInfo.coordinate
            
            // 日時を文字列で表現するためのフォーマットを指定
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            annotation.title = dateFormatter.string(from: locationInfo.recordedAt)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    private func addRoute(with userLocationLogs: [CLLocationCoordinate2D]) {
        
        print(userLocationLogs.count)
        // いったんオーバーレイを削除
        mapView.removeOverlays(mapView.overlays)
        
        // 位置情報（coordinate）のリストを渡してラインを描画
        let line = MKPolyline(coordinates: userLocationLogs, count: userLocationLogs.count)
        mapView.addOverlay(line)
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

    @IBAction func tappedDisplayRoute(_ sender: UIButton) {
        self.addRoute(with: userLocationLogs)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    // 位置情報を取得する度に呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation? = locations.last
        
        if let location = location {
            let coordinate = location.coordinate

            currentLocation = coordinate
            userLocationLogs.append(coordinate)
            
            let longitude = coordinate.longitude
            let latitude = coordinate.latitude
            print("longitude \(longitude)")
            print("latitude \(latitude)")
            
            mapView.setCenter(coordinate, animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // Lineの色や太さを設定。デフォルトでは太さが0なので描画されない
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = UIColor.red
            polyLineRenderer.lineWidth = 2.0
            
            // Lineをドットパターンにする場合は下記のような設定をする。
            //polyLineRenderer.lineDashPattern = [1, 7]
            return polyLineRenderer
        }
        return MKOverlayRenderer()
    }
}
