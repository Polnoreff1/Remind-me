//
//  NotificationService.swift
//  Remind me
//
//  Created by Andrey Versta on 08.08.2022.
//

import UserNotifications
import UIKit
import SPAlert

final class NotificationService: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func askUserForNotifications() {
        notificationCenter.requestAuthorization(
            options: [
                .alert,
                .sound,
                .alert
            ]
        ) { [weak self] isSuccess, _ in
            guard isSuccess else { return }
            self?.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }}
    }
    
    func setupNotification(with content: UNMutableNotificationContent, time: Date) {
        sendNotification(content: content, date: time)
    }
    
    private func sendNotification(
        content: UNMutableNotificationContent,
        date: Date
    ) {
        
        let resultDateDateComponents = Calendar.current.dateComponents(
            [
                .year,
                .month,
                .day,
                .hour,
                .minute
            ],
            from: date
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: resultDateDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notific", content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            AlertService.showErrorTextAlert(with: error?.localizedDescription ?? "Notification Error")
        }
        notificationCenter.delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .banner])
    }
}
