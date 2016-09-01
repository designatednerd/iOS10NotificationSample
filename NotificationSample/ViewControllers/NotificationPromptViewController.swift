//
//  NotificationPromptViewController.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import UIKit

class NotificationPromptViewController: UIViewController {
    
    var notificationHandler: VersionSpecificNotificationHandler!

    @IBAction private func nope() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func yup() {
        self.notificationHandler.requestNotificationPermissionsWithCompletion {
            [weak self]
            granted in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
