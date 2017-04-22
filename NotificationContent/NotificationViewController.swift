//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Ellen Shapiro (Work) on 8/14/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import ParrotKit
import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

    @IBOutlet fileprivate var parrotImageView: UIImageView!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var subtitleLabel: UILabel!
    @IBOutlet fileprivate var contentLabel: UILabel!
    @IBOutlet private var partyCollectionView: UICollectionView!
    @IBOutlet private var friendsCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Party.current.reloadFromDefaults()
        Friends.mine.reloadFromDefaults()
        
        ParrotCollectionViewCell.register(with: self.partyCollectionView)
        ParrotCollectionViewCell.register(with: self.friendsCollectionView)
    }
}

//MARK: - Notification Content Extension

extension NotificationViewController: UNNotificationContentExtension {
    func didReceive(_ notification: UNNotification) {
        self.contentLabel.text = notification.request.content.body
        self.titleLabel.text = notification.request.content.title
        self.subtitleLabel.text = notification.request.content.subtitle
        
        guard let parrot = PartyParrot(userInfo: notification.request.content.userInfo) else {
            assertionFailure("Couldn't create parrot from user info!")
            return
        }
        
        self.parrotImageView.image = parrot.gif.animated
    }
}
