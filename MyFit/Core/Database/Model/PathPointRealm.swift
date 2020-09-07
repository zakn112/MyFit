//
//  PathPointRealm.swift
//  MyFit
//
//  Created by Андрей Закусов on 06.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation
import RealmSwift

class PathPointRealm: Object {
    @objc dynamic var namePath:String = ""
    @objc dynamic var idPath:Int = 0
    @objc dynamic var idDate:Date = Date()
    @objc dynamic var latitude:Double = 0
    @objc dynamic var longitude:Double = 0
   
}
