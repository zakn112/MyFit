//
//  UserRealm.swift
//  MyFit
//
//  Created by Андрей Закусов on 09.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealm: Object {
    @objc dynamic var login:String = ""
    @objc dynamic var password:String = ""
    
    @objc dynamic var first_name:String = ""
    @objc dynamic var last_name:String = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}
