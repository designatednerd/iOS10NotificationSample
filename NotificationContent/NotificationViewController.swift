//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Ellen Shapiro (Work) on 8/14/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
}
