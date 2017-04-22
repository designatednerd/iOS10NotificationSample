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
    private init() {
        self.parrots = UserDefaultsWrapper.storedParty()
    }
    
    public var parrots: [PartyParrot]
    
    private func postUpdateNotification() {
        NotificationCenter
            .default
            .post(name: .PartyUpdated,
                  object: nil)
    }
    
    public mutating func reloadFromDefaults() {
        self.parrots = UserDefaultsWrapper.storedParty()
        self.postUpdateNotification()
    }
    
    public mutating func add(_ parrotToAdd: PartyParrot) {
        self.parrots.append(parrotToAdd)
        UserDefaultsWrapper.storeParty(self.parrots)
        self.postUpdateNotification()
    }
    
    public mutating func block(_ parrotToBlock: PartyParrot) {
        self.parrots = self.parrots.filter { $0 != parrotToBlock }
        UserDefaultsWrapper.storeParty(self.parrots)
        self.postUpdateNotification()
    }
}
