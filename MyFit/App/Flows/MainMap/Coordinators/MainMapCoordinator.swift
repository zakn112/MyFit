//
//  MainMapCoordinator.swift
//  MyFit
//
//  Created by Андрей Закусов on 11.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation
import UIKit

final class MainMapCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "MainMapViewController")
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        
    }
    
}

