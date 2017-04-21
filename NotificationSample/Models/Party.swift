//
//  Party.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

struct Party {
    
    static var current = Party()
    
    var parrots = [PartyParrot]()
    
    private func postUpdateNotification() {
        NotificationCenter
            .default
            .post(name: .PartyUpdated,
                  object: nil)
    }
    
    mutating func add(_ parrotToAdd: PartyParrot) {
        self.parrots.append(parrotToAdd)
        self.postUpdateNotification()
    }
    
    mutating func block(_ parrotToBlock: PartyParrot) {
        self.parrots = self.parrots.filter { $0 != parrotToBlock }
        self.postUpdateNotification()
    }
}

extension Notification.Name {
    
    static let PartyUpdated = Notification.Name(rawValue: "PartyUpdated")
}
