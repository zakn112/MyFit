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
        toLogin()
    }
    
    private func toLogin() {
// Создаём координатор главного сценария
        let coordinator = LoginCoordinator()
// Устанавливаем ему поведение на завершение
       coordinator.onFinishFlow = { [weak self, weak coordinator] in
// Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
// Заново запустим главный координатор, чтобы выбрать следующий сценарий
            self?.start()
        }
// Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
// Запустим сценарий дочернего координатора
        coordinator.start()
    }
    

}
