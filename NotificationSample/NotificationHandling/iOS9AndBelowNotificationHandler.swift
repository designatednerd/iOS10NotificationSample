//
//  iOS9AndBelowNotificationHandler.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 8/31/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation
import UIKit

//Silence warnings from the compiler about classes which are deprecated in iOS 10
@available(iOS, deprecated: 10.0)
class iOS9AndBelowNotificationHandler {
    
    fileprivate let notificationPermissionRequestedKey = "com.example.HasUserBeenAskedAboutNotifications"
    
    var permissionsCompletionWithGranted: ((Bool) -> ())?
    
    func grantedPermissions(with settings: UIUserNotificationSettings) {
        guard let permissionsGranted = self.permissionsCompletionWithGranted else {
            //Nothing to do here. 
            return
        }
        
        permissionsGranted(self.areAnyNotificationsEnabled(in: settings))
    }
    
    fileprivate func areAnyNotificationsEnabled(in settings: UIUserNotificationSettings) -> Bool {
        return settings.types.contains(.alert)
            || settings.types.contains(.sound)
            || settings.types.contains(.badge)
    }
}

//Silence warnings from the compiler about classes which are deprecated in iOS 10
@available(iOS, deprecated: 10.0)
extension iOS9AndBelowNotificationHandler: VersionSpecificNotificationHandler {
    
    func hasUserBeenAskedAboutPushNotifications(hasBeenAsked: @escaping (Bool) -> ()) {
        //Theoretically you could query UIApplication.shared.isRegisteredForRemoteNotifications,
        //but that will return no if the user has been asked and declined notifications.
        //<10, the only reliable way to track this is to store whether this has been asked.
        hasBeenAsked(UserDefaults.standard.bool(forKey: self.notificationPermissionRequestedKey))
    }
    
    func requestNotificationPermissionsWithCompletion(permissionsGranted: @escaping (Bool) -> ()) {
        self.permissionsCompletionWithGranted = permissionsGranted
        let settings = UIUserNotificationSettings(types: [
                                                    .alert,
                                                    .badge,
                                                    .sound,
                                                  ],
                                                  categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        //Track that the user has been asked.
        UserDefaults.standard.set(true, forKey: self.notificationPermissionRequestedKey)
    }
    
    func arePermissionsGranted(permissionsGranted: @escaping (Bool) -> ()) {
        guard let settings = UIApplication.shared.currentUserNotificationSettings else {
            permissionsGranted(false)
            return
        }
        
        permissionsGranted(self.areAnyNotificationsEnabled(in: settings))
    }
    
    func scheduleNotification(for parrot: PartyParrot, delay: TimeInterval) {
        let notification = UILocalNotification()
        
        notification.fireDate = Date().addingTimeInterval(delay)
        
        //You have to use the body instead of the title or it won't 
        //actually show as a notification because ¯\_(ツ)_/¯
        notification.alertBody = "\(parrot.name) wants to join the party!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = parrot.toUserInfo()
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
