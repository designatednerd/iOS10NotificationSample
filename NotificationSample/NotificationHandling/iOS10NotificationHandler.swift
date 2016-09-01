//
//  iOS10NotificationHandler.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 8/31/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation
import UserNotifications

// NOTE: This must inherit from NSObject to be able to conform to UNUserNotificationCenterDelegate
@available(iOS 10.0, *)
class iOS10NotificationHandler: NSObject {
    
    override init() {
        super.init()        
        //Set this object as the delegate to the user notification center
        UNUserNotificationCenter.current().delegate = self
    }
}

//MARK: - iOS 10

@available(iOS 10.0, *)
extension iOS10NotificationHandler: UNUserNotificationCenterDelegate {
    
    // This gets called when a notification comes in while you're in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        //Modify the notification as you wish, then call the completion handler.
        completionHandler(.alert)
    }
    
    
    // Called when the user selects an action or dismisses a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        self.handleActionWithIdentifier(identifier: response.actionIdentifier,
                                        for: userInfo,
                                        completionHandler: completionHandler)
    }
}

@available(iOS 10.0, *)
extension iOS10NotificationHandler: VersionSpecificNotificationHandler {
    
    private func getAuthStatus(status: @escaping (UNAuthorizationStatus) -> ()) {
        UNUserNotificationCenter
            .current()
            .getNotificationSettings {
                settings in
                status(settings.authorizationStatus)
        }
    }

    func hasUserBeenAskedAboutPushNotifications(hasBeenAsked: @escaping (Bool) -> ()) {
        self.getAuthStatus() {
            status in
            
            DispatchQueue.main.async {
                switch status {
                case .notDetermined: //Not asked yet
                    hasBeenAsked(false)
                case .denied, //Asked and denied
                .authorized: //Asked and accepted
                    hasBeenAsked(true)
                }
            }
        }
    }
    
    func requestNotificationPermissionsWithCompletion(permissionsGranted: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {
                granted, error in
                
                DispatchQueue.main.async {
                    if granted {
                        permissionsGranted(true)
                    } else {
                        print("Error or nil: \(error?.localizedDescription ?? "nil")")
                        permissionsGranted(false)
                    }
                }
        }
    }
    
    func arePermissionsGranted(permissionsGranted: @escaping (Bool) -> ()) {
        self.getAuthStatus() {
            status in
            
            DispatchQueue.main.async {
                switch status {
                case .notDetermined,
                     .denied:
                    permissionsGranted(false)
                case .authorized:
                    permissionsGranted(true)
                }
            }
        }
    }
}
