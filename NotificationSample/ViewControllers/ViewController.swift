//
//  ViewController.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 8/14/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var askedLabel: UILabel!
    @IBOutlet private var askButton: UIButton!
    @IBOutlet private var grantedLabel: UILabel!
    
    var notificationHandler: VersionSpecificNotificationHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let notificationHandler = self.notificationHandler else {
            assertionFailure("You're gonna want a notification handler to actually load this stuff")
            return
        }
        
        notificationHandler.hasUserBeenAskedAboutPushNotifications() {
            [weak self]
            asked in
            
            self?.userWasAskedForNotificationPermission(asked: asked)
            
            if asked {
                self?.notificationHandler.arePermissionsGranted {
                    granted in
                    
                    self?.permissionsWereGranted(granted: granted)
                }
            }
        }
    }

    //MARK: - UI setup 
    
    private func userWasAskedForNotificationPermission(asked: Bool) {
        
        if asked {
            self.askedLabel.text = "👍"
            self.askButton.isEnabled = false
            self.askButton.alpha = 0.5
        } else {
            self.askedLabel.text = "👎"
            self.permissionsWereGranted(granted: false)
            self.askButton.isEnabled = true
            self.askButton.alpha = 1
        }
    }
    
    private func permissionsWereGranted(granted: Bool) {
        if granted {
            self.grantedLabel.text = "👍"
        } else {
            self.grantedLabel.text = "👎"
        }
    }
    
    //MARK: - IBActions
    
    @IBAction private func askForPermissions() {
        self.userWasAskedForNotificationPermission(asked: true)
        
        self.notificationHandler.requestNotificationPermissionsWithCompletion {
            [weak self]
            granted in
            self?.permissionsWereGranted(granted: granted)
        }
    }
}
