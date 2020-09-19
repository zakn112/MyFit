//
//  ApplicationCoordinator.swift
//  MyFit
//
//  Created by Андрей Закусов on 10.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        if Session.shared.isLogin {
            toMap()
        } else{
            toLogin()
        }
    }
    
    private func toLogin() {
        let coordinator = LoginCoordinator()
       coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func toMap() {
        let coordinator = MainMapCoordinator()
       coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    

}
