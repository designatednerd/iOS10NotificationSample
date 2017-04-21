//
//  ViewController.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 8/14/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import ParrotKit
import UIKit

class ViewController: UIViewController {

    private enum SegueTo: String {
        case
        prompt = "ToNotificationPrompt"
    }
    
    @IBOutlet private var parrotImageView: UIImageView!
    @IBOutlet private var askedLabel: UILabel!
    @IBOutlet private var askButton: UIButton!
    @IBOutlet private var grantedLabel: UILabel!
    @IBOutlet private var sendTestNotificationButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    var notificationHandler: VersionSpecificNotificationHandler!
    
    private let parrots = PartyParrot.nonstandardParrots
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParrotCollectionViewCell.register(with: self.collectionView)
        
        // That other kind of notification
        NotificationCenter
            .default
            .addObserver(forName: .PartyUpdated,
                         object: nil,
                         queue: .main,
                         using: {
                            [weak self]
                            _ in
                            self?.collectionView.reloadData()
                         })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parrotImageView.image = ParrotGif.partyparrot.animated
        self.parrotImageView.isHidden = true
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier,
            let segueTo = SegueTo(rawValue: identifier) else {
                assertionFailure("Could not find the appropriate segue identifier!")
                return
        }
        
        switch segueTo {
        case .prompt:
            guard let destination = segue.destination as? NotificationPromptViewController else {
                return
            }
            
            destination.notificationHandler = self.notificationHandler
        }
    }

    //MARK: - UI setup 
    
    private func userWasAskedForNotificationPermission(asked: Bool) {
        if asked {
            self.askedLabel.text = "👍"
            self.askButton.isEnabled = false
            self.askButton.alpha = 0.5
            self.parrotImageView.isHidden = false
        } else {
            self.askedLabel.text = "👎"
            self.permissionsWereGranted(granted: false)
            self.askButton.isEnabled = true
            self.askButton.alpha = 1
            self.parrotImageView.isHidden = true
        }
    }
    
    private func permissionsWereGranted(granted: Bool) {
        if granted {
            self.grantedLabel.text = "👍"
            self.sendTestNotificationButton.isEnabled = true
            self.sendTestNotificationButton.alpha = 1
        } else {
            self.grantedLabel.text = "👎"
            self.sendTestNotificationButton.isEnabled = false
            self.sendTestNotificationButton.alpha = 0.5
            self.parrotImageView.image = ParrotGif.sadparrot.animated
        }
    }
    
    //MARK: - IBActions
    
    @IBAction private func sendTestNotification() {
        let randomIndex = Int(arc4random_uniform(UInt32(self.parrots.count)))
        
        let parrot = self.parrots[randomIndex]
        
        self.notificationHandler.scheduleNotification(for: parrot,
                                                      delay: 3)
    }
}
