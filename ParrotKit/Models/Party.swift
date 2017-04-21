//
//  Party.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

public struct Party {
    
    public static var current = Party()
    private init() { }
    
    public var parrots = [PartyParrot]()
    
    private func postUpdateNotification() {
        NotificationCenter
            .default
            .post(name: .PartyUpdated,
                  object: nil)
    }
    
    public mutating func add(_ parrotToAdd: PartyParrot) {
        self.parrots.append(parrotToAdd)
        self.postUpdateNotification()
    }
    
    public mutating func block(_ parrotToBlock: PartyParrot) {
        self.parrots = self.parrots.filter { $0 != parrotToBlock }
        self.postUpdateNotification()
    }
}

public extension Notification.Name {
    
    public static let PartyUpdated = Notification.Name(rawValue: "PartyUpdated")
}
