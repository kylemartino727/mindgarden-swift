//
//  NotificationHelper.swift
//  MindGarden
//
//  Created by Mark Jones on 10/25/21.
//

import Foundation
import SwiftUI

struct NotificationHelper {
    static func addOneDay() {
        let content = UNMutableNotificationContent()
        content.title = "Don't Break Your Streak!"
        content.body = "Tend to your garden by meditating."
        content.sound = UNNotificationSound.default
        let hour = Calendar.current.component( .hour, from:Date() )
        var modifiedDate = Calendar.current.date(byAdding: .hour, value: 36, to: Date())
        if hour < 11 {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 26, to: Date())
        }
        else if hour < 16 {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())
        }
        else {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 36, to: Date())
        }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        UserDefaults.standard.setValue(uuidString, forKey: "oneDayNotif")
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }

    static func addThreeDay() {
        let content = UNMutableNotificationContent()
        content.title = "The best time to plant a tree was 20 years ago."
        content.body = "The second best time is right now."
        content.sound = UNNotificationSound.default

        let modifiedDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        UserDefaults.standard.setValue(uuidString, forKey: "threeDayNotif")
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }

    //Create Date from picker selected value.
    static func createDate(weekday: Int, hour: Int, minute: Int)->Date{
           var components = DateComponents()
           components.hour = hour
           components.minute = minute
           components.year = Int(Date().get(.year))
//           components.month = Int(Date().get(.month))
//           components.day = Int(Date().get(.day))
           components.weekday = weekday // sunday = 1 ... saturday = 7
           components.weekdayOrdinal = 10
           components.timeZone = .current
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yyyy hh:mm a"
           let calendar = Calendar(identifier: .gregorian)
           print(formatter.string(from: calendar.date(from: components)!), weekday)
           return calendar.date(from: components)!
       }

       //Schedule Notification with weekly bases.
    static func scheduleNotification(at date: Date, weekDay: Int, title: String = "It's time to meditate!", subtitle: String = "Let's tend to our garden & become happier.", isMindful: Bool = false) {
           let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)

           let content = UNMutableNotificationContent()

           content.title = title
           content.subtitle = subtitle
           content.sound = UNNotificationSound.default
           let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

           // choose a random identifier
            let request = UNNotificationRequest(identifier: isMindful ? "\(weekDay)+\(date.get(.hour))" : String(weekDay), content: content, trigger: trigger)

           // add our notification request
           UNUserNotificationCenter.current().add(request)

       }
    static func deleteMindfulNotifs() {
        var identifiers = [String]()
        for weekday in 1...7 {
            for i in 8...21 {
                identifiers.append("\(weekday)+\(i)")
            }
        }
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    static func createMindfulNotifs() {
        // hours between 9 -> 22
        // 7 days a week
        // 5 notiftypes
        deleteMindfulNotifs()
        var notifTypes = UserDefaults.standard.array(forKey: "notifTypes") as! [String]
        let frequency = UserDefaults.standard.integer(forKey: "frequency")

        var firstThird = Int.random(in: 8...12)
        var secondThird = Int.random(in: 14...17)
        var finalThird = Int.random(in: 19...21)
        for weekday in 1...7 {
            notifTypes = notifTypes.shuffled()
            for i in 0...frequency {
                var randNum = 0
                if frequency == 1 {
                    firstThird = Int.random(in: 8...21)
                    randNum = 0
                } else if frequency == 2 {
                    firstThird = Int.random(in: 8...14)
                    secondThird = Int.random(in: 15...21)
                    randNum = i % 2
                } else {
                   firstThird = Int.random(in: 8...12)
                   secondThird = Int.random(in: 14...17)
                   finalThird = Int.random(in: 19...21)
                   randNum = i % 3
                }

                let arr = [firstThird, secondThird, finalThird]
                let notifType = i % notifTypes.count
                print(weekday, arr[randNum], randNum)
                if notifTypes[notifType] == "gratitude" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Be thankful for what you have;", subtitle: "you'll end up having more.", isMindful: true)
                } else if notifTypes[notifType] == "breathing" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Take a deep breath.", subtitle: "Exhale & let go.", isMindful: true)
                } else if notifTypes[notifType] == "smiling" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Life is short.", subtitle: "Smile while you have teeth", isMindful: true)
                } else if notifTypes[notifType] == "loving" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Everyone is fighting their own battles.", subtitle: "Do your part & show some love while they're still here.", isMindful: true)
                } else { // present
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Do not ruin today by mourning ", subtitle: "tomorrow. Live right now.", isMindful: true)
                }
            }
        }
    }

}

