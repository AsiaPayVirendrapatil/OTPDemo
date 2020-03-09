//
//  AppDelegate+PushNotifications.swift
//  ChatApp
//
//  Created by Bhushan  Borse on 12/08/19.
//  Copyright © 2019 Bhushan  Borse. All rights reserved.
//

import Foundation

import UserNotifications
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "general") { error in
            print("Subscribed to general topic")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    /// Register for push notifications
    func registerForPushNotification(){
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()
    }
}


extension AppDelegate: MessagingDelegate {
    
    func application(received remoteMessage: MessagingRemoteMessage) {
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token (Have to copy this token id for testing.) ====> \(fcmToken) <=====")
    }
}
