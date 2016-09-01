//
//  ParrotAction.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation
import UserNotifications

enum ParrotAction: String {
    case
    block = "com.example.action.block",
    add = "com.example.action.add",
    partyWith = "com.example.action.partywith"
    
    func performWith(parrot: PartyParrot) {
        switch self {
        case .add:
            ParrotAPIController.add(parrot: parrot)
        case .block:
            ParrotAPIController.block(parrot: parrot)
        case .partyWith:
            Party.current.add(parrot: parrot)
        }
    }
    
    @available(iOS 10, *)
    static func configureNotificationActions() {
        let blockAction = UNNotificationAction(identifier: ParrotAction.block.rawValue,
                                               title: "Block Parrot")
        
        let addAction = UNNotificationAction(identifier: ParrotAction.add.rawValue,
                                             title: "Add Parrot as Friend")
        
        let partyWithAction = UNNotificationAction(identifier: ParrotAction.partyWith.rawValue,
                                                   title: "Party With Parrot")

        let category =
            UNNotificationCategory(identifier: NotificationCategory.partyRequest.rawValue,
                                   actions: [
                                    blockAction,
                                    addAction,
                                    partyWithAction,
                                   ],
                                   intentIdentifiers: [])
        
        UNUserNotificationCenter
            .current()
            .setNotificationCategories([category])
    }
}
