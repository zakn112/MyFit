//
//  LoginCoordinator.swift
//  MyFit
//
//  Created by Андрей Закусов on 10.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation
import UIKit
final class LoginCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        controller.onSingin = { [weak self] in
            self?.showRecoverModule()
        }
        
        controller.onMap = { [weak self] in
             self?.onFinishFlow?()
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRecoverModule() {
        
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SinginViewController") as! SinginViewController
        
        controller.onMap = { [weak self] in
            self?.onFinishFlow?()
        }
        rootController?.pushViewController(controller, animated: true)
    }
    
}
