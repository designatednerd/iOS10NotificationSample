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
    
    @IBOutlet var parrotImageViews: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let waveImages = ParrotGif.wave()
        
        for i in 0..<self.parrotImageViews.count {
            let imageView = self.parrotImageViews[i]
            let imageIndex = i % waveImages.count
            let image = waveImages[imageIndex]
            
            imageView.image = image
        }
    }
    

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
