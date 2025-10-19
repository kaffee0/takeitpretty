//
//  NotificationSchedule.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/09.
//
import UserNotifications

func scheduleInactivityNotification() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        if granted {
            let content = UNMutableNotificationContent()
            content.title = "Long time no seeeeee"
            content.body = "I'm waiting for you to play again"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
            let request = UNNotificationRequest(identifier: "inactivityNotification", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("通知スケジュールエラー: \(error.localizedDescription)")
                }
            }
        } else {
            print("通知の許可が得られませんでした")
        }
    }
}
