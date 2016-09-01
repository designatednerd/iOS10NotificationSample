//
//  VersionSpecificNotificationHandler.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 8/31/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocol declaration

enum NotificationCategory: String {
    case
    partyRequest = "com.example.notificaton.partyrequest"
}

protocol VersionSpecificNotificationHandler {
    
    func handleActionWithIdentifier(identifier: String?,
                                    for userInfo: [AnyHashable : Any]?,
                                    completionHandler: @escaping () -> Swift.Void)
    
    func hasUserBeenAskedAboutPushNotifications(hasBeenAsked: @escaping (Bool) -> ())

    func requestNotificationPermissionsWithCompletion(permissionsGranted: @escaping (Bool) -> ())
    
    func arePermissionsGranted(permissionsGranted: @escaping (Bool) -> ())
    
    func successfullyRegisteredForNotifications(deviceToken: Data)
    
    func failedToRegisterForNotifications(error: Error)
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)
    
    func scheduleNotification(for parrot: PartyParrot, delay: TimeInterval)
}

//MARK: Default implementation

//In the default implementaton, handle things which are the same across multiple
extension VersionSpecificNotificationHandler {
    
    func handleActionWithIdentifier(identifier: String?,
                                    for userInfo: [AnyHashable : Any]?,
                                    completionHandler: @escaping () -> Swift.Void) {
        guard
            let actionIdentifier = identifier,
            let action = ParrotAction(rawValue: actionIdentifier),
            let parrotInfo = userInfo,
            let parrot = PartyParrot(userInfo: parrotInfo) else {
                //Nothing to do here except call completion and bail.
                completionHandler()
                return
        }

        action.performWith(parrot: parrot)
        completionHandler()
    }
    
    func successfullyRegisteredForNotifications(deviceToken: Data) {
        ParrotAPIController.sendDeviceTokenToOurServer(token: deviceToken)
    }
    
    func failedToRegisterForNotifications(error: Error) {
        debugPrint("Error registering for notifications \(error)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        guard let parrot = PartyParrot(userInfo: userInfo) else {
            completionHandler(.noData)
            return
        }
        
        ParrotAPIController.getInfo(for: parrot) {
            completionHandler(.newData)
        }        
    }
}
