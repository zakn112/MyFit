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
    var locationManager = LocationManager.instance
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
        _ = locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location, let self = self else { return }
                if self.isPathStarted {
                    self.routePath?.add(location.coordinate)
                    self.pathCoordinates.append(location.coordinate)
                    // Обновляем путь у линии маршрута путём повторного присвоения
                    self.route?.path = self.routePath
                    print(location.coordinate)
                    
                    // Чтобы наблюдать за движением, установим камеру на только что добавленную
                    // точку
                    let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                    self.mapView.animate(to: position)
                }
            }
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
            locationManager.stopUpdatingLocation()
            
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
            
            locationManager.startUpdatingLocation()
            
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
        var lastPoin:CLLocationCoordinate2D?
        for point in lastRout {
            routePath?.add(point)
            lastPoin = point
        }
        route?.path = routePath
        
        if let lastPoin = lastPoin {
            let position = GMSCameraPosition.camera(withTarget: lastPoin, zoom: 17)
            self.mapView.animate(to: position)
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
 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
