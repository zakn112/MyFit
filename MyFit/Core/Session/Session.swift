//
//  Session.swift
//  MyFit
//
//  Created by Андрей Закусов on 19.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation
import UIKit

class Session {
    
    static let shared = Session()
    
    var isLogin = false
    var avatarImage: UIImage?
    
    
    private init() {
    }
}
