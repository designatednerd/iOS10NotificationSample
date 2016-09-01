//
//  AppDelegate.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 8/14/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notificationHandler: VersionSpecificNotificationHandler!
    
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        //Assign the appropriate notification handler as early in the app lifecycle as possible.
        if #available(iOS 10.0, *) {
            self.notificationHandler = iOS10NotificationHandler()
        } else {
            self.notificationHandler = iOS9AndBelowNotificationHandler()
        }
        
        guard let rootVC = self.window?.rootViewController as? ViewController else {
            assertionFailure("VC not found!")
            return false
        }
        
        rootVC.notificationHandler = self.notificationHandler
        
        return true
    }
}

//MARK: Notification Handling for All versions of iOS

extension AppDelegate {
    
    //MARK: - registering
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.notificationHandler.successfullyRegisteredForNotifications(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.notificationHandler.failedToRegisterForNotifications(error: error)
    }
    
    //MARK: - Background notification handling 
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        self.notificationHandler.application(application,
                                             didReceiveRemoteNotification: userInfo,
                                             fetchCompletionHandler: completionHandler)
    }
}

//MARK: Notification handling for iOS 9 and below 

@available(iOS, deprecated: 10.0)
extension AppDelegate {
    
    @objc(application:didRegisterUserNotificationSettings:)
    func application(_ application: UIApplication,
                     didRegister notificationSettings: UIUserNotificationSettings) {
        //Kick off the request to APNS
        application.registerForRemoteNotifications()
        
        guard let notificationHandler = self.notificationHandler as? iOS9AndBelowNotificationHandler else {
            return
        }
        
        notificationHandler.grantedPermissions(with: notificationSettings)
    }
    
    //MARK: Receiving plain vanilla notifications
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //Handle iOS 9 or below notification
    }
    
    @objc(application:didReceiveLocalNotification:)
    func application(_ application: UIApplication,
                     didReceive notification: UILocalNotification) {
        //Handle iOS 9 or below local notification
    }
    
    //MARK: Handling actions
    
    @objc(application:handleActionWithIdentifier:forLocalNotification:completionHandler:)
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     for notification: UILocalNotification,
                     completionHandler: @escaping () -> Swift.Void) {
        self.notificationHandler.handleActionWithIdentifier(identifier: identifier,
                                                            for: notification.userInfo,
                                                            completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     forRemoteNotification userInfo: [AnyHashable : Any],
                     withResponseInfo responseInfo: [AnyHashable : Any],
                     completionHandler: @escaping () -> Swift.Void) {
        self.notificationHandler.handleActionWithIdentifier(identifier: identifier,
                                                            for: userInfo,
                                                            completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     forRemoteNotification userInfo: [AnyHashable : Any],
                     completionHandler: @escaping () -> Swift.Void) {
        self.notificationHandler.handleActionWithIdentifier(identifier: identifier,
                                                            for: userInfo,
                                                            completionHandler: completionHandler)
    }
}

