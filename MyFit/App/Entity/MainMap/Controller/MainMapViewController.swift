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
    
    @IBOutlet weak var mapView: GMSMapView!
    
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
        locationManager?.startUpdatingLocation()
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
            addMarker(markerCoordinate: firstLocation.coordinate)
            moveToCoordinate(markerCoordinate: firstLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
