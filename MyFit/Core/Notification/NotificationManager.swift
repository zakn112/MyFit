//
//  NotificationManager.swift
//  MyFit
//
//  Created by Андрей Закусов on 22.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import Foundation
import NotificationCenter

class NotificationManager{
    static let shared = NotificationManager()
    
    func sendNotification(title: String, subtitle: String, body: String, timeInterval: Double){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            
            self.sendNotificatioRequest(
                content: self.makeNotificationContent(title: title, subtitle: subtitle, body: body),
                trigger: self.makeIntervalNotificatioTrigger(timeInterval: timeInterval)
            )
        }
        
    }
    
    private func makeNotificationContent(title: String, subtitle: String, body: String) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = 4
        return content
    }
    
    private func makeIntervalNotificatioTrigger(timeInterval: Double) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
    }
    
    private func sendNotificatioRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - phrases
extension NotificationManager{
    func msgGoStart(){
        NotificationManager.shared.sendNotification(title: "Пора продолжить маршрут",
                                                    subtitle: "MyFit",
                                                    body: "Ты уже давно остановился, продолжай свой путь, осталось не много!",
                                                    timeInterval: 20)
    }
    
    func msgGoBack(){
        NotificationManager.shared.sendNotification(title: "Вернись в приложение",
                                                    subtitle: "MyFit",
                                                    body: "Ты уже давно не тренировался, вернись и продолжи тренировку!",
                                                    timeInterval: 20)
    }
    
}


