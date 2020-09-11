//
//  RealmDatabase.swift
//  MyFit
//
//  Created by Андрей Закусов on 06.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//
import Foundation
import RealmSwift
import GoogleMaps

class DBRealmConfig {
    static let shared = DBRealmConfig()
    private init(){}
    
    func setConfiguration() -> () {
        let config = Realm.Configuration(
            schemaVersion: 2
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
}

class DBRealm {
    
    static let shared = DBRealm()
    
    private init(){}
    
    func getNextIdPath() -> Int {
        let realm = try! Realm()
        
        let points = realm.objects(PathPointRealm.self)
        if points.count == 0 {
            return 1
        }else{
            var maxId = 0
            for point in points {
                if maxId < point.idPath {
                    maxId = point.idPath
                }
            }
            return maxId + 1
        }
        
    }
    
    func getLastRoutePath() -> [CLLocationCoordinate2D]{
      let idPath = getNextIdPath() - 1
        let realm = try! Realm()
        let points = realm.objects(PathPointRealm.self).filter("idPath == %@", idPath)
        
        var lastRoutePath:[CLLocationCoordinate2D] = []
        
        for point in points {
            lastRoutePath.append(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        }
        
        return lastRoutePath
    }
    
    func writeRoutePath(routePath: [CLLocationCoordinate2D]){
        let idPath = getNextIdPath()
        let realm = try! Realm()
        try! realm.write {
            for pathPint in routePath {
                let object = PathPointRealm()
                object.idPath = idPath
                object.latitude = pathPint.latitude
                object.longitude = pathPint.longitude
                realm.add(object)
            }
        }
    }
    
    
}

extension DBRealm {
    func checkUser(login: String, password: String) -> Bool {
        let realm = try! Realm()
        
        if let _ = realm.objects(UserRealm.self).filter("login == %@ AND password == %@", login, password).first {
            return true
        }else{
            return false
        }
    }
    
    func checkUserLogin(login: String) -> Bool {
         let realm = try! Realm()
         
         if let _ = realm.objects(UserRealm.self).filter("login == %@", login).first {
             return true
         }else{
             return false
         }
     }
    
    func addUser(login: String, password: String) -> Bool{
        if checkUserLogin(login: login) {
            return false
        }
        
        let realm = try! Realm()
        do {
            try realm.write {
                let object = UserRealm()
                object.login = login
                object.password = password
                realm.add(object)
                
            }
            return true
            
        }catch{
            return false
        }
    }
}
