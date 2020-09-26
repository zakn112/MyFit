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
import UserNotifications

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
        
        UNUserNotificationCenter.current().delegate = self
        
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

                    if let _ = Session.shared.avatarImage {
                        self.addMarker(markerCoordinate: location.coordinate)
                    }
                    
                    // Чтобы наблюдать за движением, установим камеру на только что добавленную
                    // точку
                    let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                    self.mapView.animate(to: position)
                }
            }
    }
    
    func addMarker(markerCoordinate: CLLocationCoordinate2D) {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let view = UIImageView(frame: rect)
        view.image = Session.shared.avatarImage

        let marker = GMSMarker(position: markerCoordinate)
        marker.iconView = view
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
            
            NotificationManager.shared.msgGoStart()
            
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
    
    
    @IBAction func setAvatarButtonPress(_ sender: Any) {
        // Проверка, поддерживает ли устройство камеру
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        // Создаём контроллер и настраиваем его
                let imagePickerController = UIImagePickerController()
        // Источник изображений: камера
                imagePickerController.sourceType = .photoLibrary
        // Изображение можно редактировать
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                
        // Показываем контроллер
                present(imagePickerController, animated: true)

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

// MARK: - GMSMapViewDelegate
extension MainMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}

// MARK: - CLLocationManagerDelegate
extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

// MARK: - UNUserNotificationCenterDelegate

extension MainMapViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension MainMapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    internal func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let image = extractImage(from: info)
        Session.shared.avatarImage = image

        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}
