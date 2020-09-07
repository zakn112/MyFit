//
//  MainMapViewController.swift
//  MyFit
//
//  Created by Андрей Закусов on 31.08.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MainMapViewController: UIViewController {
    var locationManager: CLLocationManager?
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var pathCoordinates:[CLLocationCoordinate2D] = []
    var isPathStarted = false
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var startStopButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        configureMap()
        configureLocationManager()

    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.delegate = self
    }
    
    func addMarker(markerCoordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: markerCoordinate)
        marker.map = mapView
    }
    
    func moveToCoordinate(markerCoordinate: CLLocationCoordinate2D){
      mapView.animate(toLocation: markerCoordinate)
    }

    @IBAction func startButtonPress(_ sender: Any) {
        if isPathStarted {
            locationManager?.stopUpdatingLocation()
            
            DBRealm.shared.writeRoutePath(routePath: pathCoordinates)
            pathCoordinates = []
            
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath()
            route?.map = mapView
            
            startStopButtom.setTitle("Start", for: .normal)
            isPathStarted = false
        }else {
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath()
            route?.map = mapView
            
            locationManager?.startUpdatingLocation()
            
            startStopButtom.setTitle("Stop", for: .normal)
            isPathStarted = true
        }
    }
    
    
    @IBAction func viewLastRoutButtonPress(_ sender: Any) {
        let lastRout = DBRealm.shared.getLastRoutePath()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        for point in lastRout {
            routePath?.add(point)
            route?.path = routePath
            moveToCoordinate(markerCoordinate: point)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let firstLocation = locations.first {
            routePath?.add(firstLocation.coordinate)
            route?.path = routePath
            moveToCoordinate(markerCoordinate: firstLocation.coordinate)
            pathCoordinates.append(firstLocation.coordinate)
    
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
