//
//  Notifications.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import Foundation
import UserNotifications

func sendNotification(subtitle: String = "", body: String = "") {
    let content = UNMutableNotificationContent()
    content.title = "SpaceBar"
    
    if !subtitle.isEmpty {
        content.subtitle = subtitle
    }
    
    if body.count > 0 {
        content.body = body
    }
    
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(
        identifier: uuidString,
        content: content, trigger: nil)
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    notificationCenter.add(request)
}

