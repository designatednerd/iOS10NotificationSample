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
        
        //Set up actions
        ParrotAction.configureNotificationActions()
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

//MARK: - VersionSpecificNotificationHandler conformance

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
    
    func scheduleNotification(for parrot: PartyParrot, delay: TimeInterval) {
        guard
            let imageURL = Bundle.main.url(forResource: parrot.gif.rawValue, withExtension: "gif"),
            let attachment = try? UNNotificationAttachment(identifier: parrot.gif.rawValue,
                                                           url: imageURL,
                                                           options: .none) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "\(parrot.name) wants to join the party!"
        content.subtitle = "What would you like to do?"
        content.body = "You can either add \(parrot.name) as a friend, block \(parrot.name), or add \(parrot.name) to your party."
        content.attachments = [attachment]
        
        
        //Note: For a remote notification to invoke your Notification Content extension, you'd need to add this same category identifier as the value for the category key in the payload dictionary.
        content.categoryIdentifier = NotificationCategory.partyRequest.rawValue
        
        //Set up a time-based trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        //Set up the request based on the trigger.
        let request = UNNotificationRequest(identifier: parrot.gif.rawValue,
                                            content: content,
                                            trigger: trigger)
        
        //Schedule the notification
        UNUserNotificationCenter.current().add(request) {
            error in
            if let error = error {
                debugPrint("Error scheduling notification: \(error)")
            } else {
                debugPrint("Notification added!")
            }
        }
    }
}
