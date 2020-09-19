//
//  Session.swift
//  MyFit
//
//  Created by Андрей Закусов on 19.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation

class Session {
    
    static let shared = Session()
    
    var isLogin = false
    
    private init() {
    }
}
